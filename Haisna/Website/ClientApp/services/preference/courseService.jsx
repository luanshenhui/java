/**
 * @file コーステーブルAPIアクセス処理
 */
import axios from 'axios';

const courseService = {
  // 指定IDのコース情報取得
  getCourse: (params) => {
    const url = `/api/v1/courses/${params.cscd}`;
    return axios
      .get(url)
      .then((res) => res.data);
  },
  // 今日の受診者取得（コース別）の一覧を取得
  getSelDateCourse: ({ params }) => {
    // 今日の受診者取得（コース別）の一覧を取得
    // urlの定義
    const url = '/api/v1/consultations/courses';
    // 今日の受診者取得（コース別）の一覧を取得API呼び出し
    return axios
      .get(url, {
        params,
      })
      .then((res) => {
        // 成功時は今日の受診者取得（コース別）の一覧を取得成功アクションを呼び出す
        const { data } = res;
        return { data };
      });
  },

  // コース履歴の一覧取得
  getCourseHistory: ({ ...params }) => {
    const { cscd } = params;
    const url = `/api/v1/courses/${cscd}/histories`;

    return axios
      .get(url, {
      // axios標準では404エラーも例外として扱われるため、500未満であれば正常となるよう変更
      // (アプリケーション規模が大きくなってきたら1ヶ所で定義するように変更したほうがよいかもしれない)
        validateStatus: (status) => (status < 500),
      })
      .then((res) => ({ courseHistoryData: res.data }));
  },

  // 契約適用期間に適用可能なコースカウント取得
  getHistoryCount: ({ data }) => {
    const url = '/api/v1/courses/count';
    return axios
      .get(url, {
        params: data,
        // axios標準では404エラーも例外として扱われるため、500未満であれば正常となるよう変更
        // (アプリケーション規模が大きくなってきたら1ヶ所で定義するように変更したほうがよいかもしれない)
        validateStatus: (status) => (status < 500),
      })
      .then((res) => ({ data: res.data }));
  },
};

export default courseService;
