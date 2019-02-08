import dayjs from 'dayjs'

export function dateFormat(date, fmt = 'YYYY-MM-DD HH:mm:ss') {
  if(!date) {
    return '-'
  }
  return dayjs(date).format(fmt)
}
