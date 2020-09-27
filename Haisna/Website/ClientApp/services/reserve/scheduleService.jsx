import axios from 'axios';

const scheduleService = {
  getRsvGrpList: (payload) => {
    // 指定コースにおける有効な予約群コース受診予約群情報を取得する
    const { cscd } = payload;

    const params = Object.keys(payload).reduce(
      (accum, key) => {
        if (key !== 'cscd') {
          return { ...accum, [key]: payload[key] };
        }
        return accum;
      },
      {},
    );

    const url = `/api/v1/schedules/${cscd}/reservationgroups`;
    return axios
      .get(url, {
        params,
        validateStatus: (status) => (status === 404 || status < 400),
      })
      .then((res) => res.data);
  },
  getRsvGrpListAll: () => {
    // 全ての予約群を読み込む
    const url = '/api/v1/reservationgroups';
    return axios
      .get(url, {
        validateStatus: (status) => (status === 404 || status < 400),
      })
      .then((res) => res.data);
  },
};

export default scheduleService;
