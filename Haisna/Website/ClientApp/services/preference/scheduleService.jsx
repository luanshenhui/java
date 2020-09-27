import axios from 'axios';
import moment from 'moment';


const scheduleService = {
  getScheduleh: ({ params }) => {
    // 病院スケジュール一覧取得
    // urlの定義
    const url = '/api/v1/hospitalschedules';
    // 病院スケジュール一覧取得API呼び出し
    return axios
      .get(url, {
        params,
        // axios標準では404エラーも例外として扱われるため、500未満であれば正常となるよう変更
        // (アプリケーション規模が大きくなってきたら1ヶ所で定義するように変更したほうがよいかもしれない)
        validateStatus: (status) => (status < 500),
      })
      .then((res) => {
        // 成功時は病院スケジュール一覧取得成功アクションを呼び出す
        const { data = [] } = res;
        return { data };
      });
  },
  getRsvFraList: () => {
    // 予約枠の一覧取得
    // urlの定義
    const url = '/api/v1/reservations';
    return axios
      .get(url)
      .then((res) => (res.data));
  },
  getCourseListRsvGrpManaged: () => {
    // コース受診予約群をもつコースのみを取得
    // urlの定義
    const url = '/api/v1/courses/managedreservationgroup';
    // コース受診予約群をもつコースのみを取得API呼び出し
    return axios
      .get(url, {
        // axios標準では404エラーも例外として扱われるため、500未満であれば正常となるよう変更
        // (アプリケーション規模が大きくなってきたら1ヶ所で定義するように変更したほうがよいかもしれない)
        validateStatus: (status) => (status < 500),
      })
      .then((res) => {
        // 成功時はコース受診予約群をもつコースのみを取得成功アクションを呼び出す
        const { data = [] } = res;
        return { data };
      });
  },
  getRsvGrpList: ({ params }) => {
    // すべての予約群を取得
    // urlの定義
    const url = '/api/v1/reservationgroups';
    // すべての予約群を取得API呼び出し
    return axios
      .get(url, {
        params,
        // axios標準では404エラーも例外として扱われるため、500未満であれば正常となるよう変更
        // (アプリケーション規模が大きくなってきたら1ヶ所で定義するように変更したほうがよいかもしれない)
        validateStatus: (status) => (status < 500),
      })
      .then((res) => {
        // 成功時はすべての予約群を取得成功アクションを呼び出す
        const { data = [] } = res;
        return { data };
      });
  },
  // 特定コースコードの予約群を取得
  getCscdRsvGrpList: (payload) => {
    const { cscd } = payload;
    // パラメータを定義
    const params = { ...payload };
    delete params.cscd;
    // urlを定義
    const url = `/api/v1/schedules/${cscd}/reservationgroups`;
    return axios
      .get(url, {
        params,
        validateStatus: (status) => (status === 404 || status < 400),
      })
      .then((res) => res.data || []);
  },
  getRsvFraMngList: (conditions) => {
    // 索条件に従って予約人数管理情報の一覧を取得
    // urlの定義
    const url = '/api/v1/schedules';
    // すべての予約群を取得API呼び出し
    return axios
      .get(url, {
        params: conditions,
        // axios標準では404エラーも例外として扱われるため、500未満であれば正常となるよう変更
        // (アプリケーション規模が大きくなってきたら1ヶ所で定義するように変更したほうがよいかもしれない)
        validateStatus: (status) => (status < 500),
      })
      .then((res) => ({ data: res.data }));
  },
  GetCalcDate: ({ params }) => {
    // urlの定義
    const url = '/api/v1/schedules/GetCalcDate';
    // 計上日取得API呼び出し
    return axios
      .get(url, {
        params,
      })
      .then((res) => res.data);
  },
  // 指定年月の予約空き状況取得(予約番号指定)
  getEmptyCalendarFromRsvNo: (payload) => {
    const url = '/api/v1/calendars/monthly/alterable';
    return axios
      .post(url, payload, {
        validateStatus: (status) => (status === 404 || status < 400),
      })
      .then((res) => res.data);
  },
  getRsvFraMngListCapacity: (conditions) => {
    // urlの定義
    const url = '/api/v1/schedules/capacity';
    const SelCsCd = [];
    const array = Object.keys(conditions.conditions);
    for (let i = 0; i < array.length; i += 1) {
      if (conditions.conditions[array[i]] === '1') {
        SelCsCd.push(array[i]);
      }
    }
    const StrDate = conditions.startDate;
    const EndDate = moment(StrDate).add(6, 'd').format('YYYY/MM/DD');
    const params = { SelCsCd, StrDate, EndDate };
    return axios
      .post(url, {
        ...params,
      })
      .then((res) => res.data);
  },

  // 予約枠登録 確認
  insertRsvFra: ({ rsvFraData }) => {
    const method = 'POST';
    // urlの定義
    const url = '/api/v1/schedules/bulk';
    return axios({
      method,
      url,
      data: rsvFraData,
    })
      .then(() => ({}));
  },
  // 予約枠更新 確認
  updateRsvFra: ({ rsvFraData }) => {
    const method = 'PUT';
    // urlの定義
    const url = '/api/v1/schedules/bulk';
    return axios({
      method,
      url,
      data: rsvFraData,
    })
      .then(() => ({}));
  },
  // 予約枠削除
  deleteRsvFra: ({ rsvFraData }) => {
    const { cslDate, csCd, rsvGrpCd } = rsvFraData;
    const method = 'DELETE';
    // urlの定義
    const url = `/api/v1/schedules/${cslDate}/${csCd}/${rsvGrpCd}/`;
    return axios({
      method,
      url,
      cslDate,
      csCd,
      rsvGrpCd,
    })
      .then(() => ({}));
  },
  // 休診日設定 保存
  updateHospitalSchedule: (calendarData) => {
    const method = 'PUT';
    // urlの定義
    const url = '/api/v1/hospitalschedules';
    return axios({
      method,
      url,
      data: calendarData,
    })
      .then(() => ({}));
  },
  // 予約枠のコピー
  copyRsvFraMng: (inputItem) => {
    const method = 'POST';
    // urlの定義
    const url = '/api/v1/copyrsvframng';
    return axios({
      method,
      url,
      data: inputItem,
    })
      .then((res) => res);
  },
};

export default scheduleService;
