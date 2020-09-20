class Record < ApplicationRecord
    belongs_to :user, required: false
    belongs_to :approver,required: false
    has_many :record_logs
    enum status: {
        refusal: -2,  # 被驳回
        cancel: -1,  # 取消申请
        created: 0,
        superior: 1,  # 上级
        college: 2,   # 学校
        filing: 3     # 组织部备案
    }

    store :exdata, accessors: [:unit_opinion, :leader_opinion,:remark, :back_lat, :back_lon, :travel], coder: JSON

    # ransack_alias :user, :user_realname_or_user_mobile

    # 返回某一状态的审核人
    def approver_on(kind)
        record_logs.to_a.detect {|log| log.kind == kind.to_s }
    end

    def to_pdf
        cell_padding = 11
        @pdf = Prawn::Document.new
        @pdf.font_families.update('SourceHanSans' => {
            :normal => Rails.root.join("app/assets/fonts/source_han_sans/SourceHanSansCN-Regular.ttf"),
            :italic => Rails.root.join("app/assets/fonts/source_han_sans/SourceHanSansCN-Regular.ttf"),
            :bold => Rails.root.join("app/assets/fonts/source_han_sans/SourceHanSansCN-Bold.ttf"),
            :bold_italic => Rails.root.join("app/assets/fonts/source_han_sans/SourceHanSansCN-Bold.ttf")
        })
        @pdf.font 'SourceHanSans'
        @pdf.text '河北农业大学处级干部外出登记表', align: :center, size: 22, style: :bold
        @pdf.move_down 24
        @pdf.text "【编号】#{created_at.to_i}", align: :right
        @pdf.move_down 12
        qrcode = RQRCode::QRCode.new("inhe://records?id=#{id}", :level=>:h, :size => 5)
        qr_file = "/tmp/hebau_reocrds_#{id}.png"
        qrcode.as_png(
            resize_gte_to: false,
            resize_exactly_to: false,
            fill: 'white',
            color: 'black',
            size: 75,
            border_modules: 0,
            module_px_size: 6,
            file: qr_file
        )
        remark_table = @pdf.make_table(
            [[td(remark),{image: qr_file}]],
            { 
                width: 440 - cell_padding * 2,
                cell_style:{ borders: [], padding: 0 },
                position: :left,
                column_widths: {1 => 70}
            }
        )
        final_unit_opinion = self.unit_opinion
        final_leader_opinion = self.leader_opinion
        record_logs.each do |log|
            final_leader_opinion = "#{log.remark}\n\n\n#{log.user.try(:realname)} #{log.created_at.strftime('%Y-%m-%d')}" if log.college?
            final_unit_opinion = "#{log.remark}\n\n\n#{log.user.try(:realname)} #{log.created_at.strftime('%Y-%m-%d')}" if log.superior?
         end
        @pdf.table([ 
            [th('姓 名'),td(user.try(:realname)),th('职 务'),td(user.try(:job))],
            [th('外出时间'),td("#{begin_at.strftime('%Y年%m月%d日')} ~ #{end_at.strftime('%Y年%m月%d日')}，共#{(end_at.to_date - begin_at.to_date).to_i + 1}天",{colspan: 3})],
            [th('外出地点'),td(address),th('联系电话'),td(tel)],
            [th('外出事由'),td(cause,{colspan: 3})],
            [th('工作代管同志联系信息',{colspan: 4})],
            [th('姓 名'),td(agent),th('移动电话'),td(agent_mobile)],
            # [th('姓 名'),td(agent),th('职 务'),td(agent_office)],
            # [th('办公电话'),td(agent_office_tel),th('移动电话'),td(agent_mobile)],
            [th('审批意见',{colspan: 4})],
            [th('单位意见',{valign: :center}),td(final_unit_opinion,{colspan: 3, height: 100})],
            [th('校领导 意见',{valign: :center}),td(final_leader_opinion,{colspan: 3, height: 100})],
            [th('销假时间'),td(back_as_human,{colspan: 3})],
            [th('备注',{valign: :center}),@pdf.make_cell(remark_table,{colspan: 3,height: 100})]
        ],column_widths: [100,170,100,170], cell_style: { padding: cell_padding }, position: :center)
        @pdf.move_down 12
        # @pdf.text '注：此表一式两份，一份作为财务处经费报销依据；一份交组织部登记备案。', align: :center, size: 14
        data = @pdf.render
        File.delete(qr_file) if File.exist?(qr_file)
        data
    end
 

    private

    after_update :status_log , if: :saved_change_to_status?
    def status_log
        self.record_logs.create kind: self.status, user_id: self.approver_id, remark: self.unit_opinion || self.leader_opinion || self.remark
    end

    def back_as_human
        back_time = back_at ? back_at.strftime('%Y-%m-%d %H:%M') : ''
        if back_at && back_at <= end_at + 1.day
            "按期销假 #{back_time}"
        elsif back_at && back_at > end_at + 1.day
            "超期销假 #{back_time}"
        elsif !back_at && Time.now > end_at
            "超期未销假 #{back_time}"
        else
            ''
        end
    end

    def td(text,options = {})
        data = {content: text, size: 16, text_color: '666666'}.update(options)
        @pdf.make_cell data
    end

    def th(text,options = {})
        # {content: text, align: :center, size: 16, font_style: :bold},
        data = {content: text, align: :center, size: 16}.update(options)
        @pdf.make_cell data
    end
end
