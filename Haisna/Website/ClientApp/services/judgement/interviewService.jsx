import axios from 'axios';


const interviewService = {

  // オプション検査名称取得
  getInteviewOptItem: (conditions) => {
    const { rsvno } = conditions;
    // urlの定義
    const url = `/api/v1/interviews/${rsvno}/options`;

    // オプション検査名称取得API呼び出し
    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => res.data);
  },

  // 予約番号をキーに指定対象受診者の検査結果歴取得
  getHistoryRslList: (conditions) => {
    const { rsvno, grpcd } = conditions;
    // urlの定義
    const url = `/api/v1/interviews/${rsvno}/groups/${grpcd}/results`;

    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => res.data);
  },

  // 検索条件に従い判定結果一覧を抽出する
  selectJudHistoryRslList: (conditions) => {
    const { rsvNo } = conditions;
    // 判定結果一覧取得
    // urlの定義
    const url = `/api/v1/consultations/${rsvNo}/groups/results`;

    // 判定結果一覧取得API呼び出し
    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => {
        // 成功時は総合コメント取得取得成功アクションを呼び出す
        const { data = [] } = res;

        return { data };
      });
  },
  // 検索条件に従い受診情報一覧を抽出する
  getHistories: (conditions) => {
    const { rsvNo } = conditions;
    // 受診情報一覧取得
    // urlの定義
    const url = `/api/v1/interviews/${rsvNo}/histories`;
    // 受診情報一覧取得API呼び出し
    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => {
        // 成功時は総合コメント取得取得成功アクションを呼び出す
        const historiesData = res.data;
        return { historiesData };
      });
  },
  // 判定医検索
  getHistoryRsList: (conditions) => {
    const { rsvNo, grpCd } = conditions;
    // urlの定義
    const url = `/api/v1/interviews/${rsvNo}/groups/${grpCd}/results`;
    // 判定医取得API呼び出し
    return axios
      .get(url, {
        params: conditions,
        validateStatus: (status) => (status < 500),
      })
      .then((res) => {
        // 成功時は判定医取得成功アクションを呼び出す
        const historyRslData = res.data;
        return { historyRslData };
      });
  },
  // 病歴検索
  getHistoryRslListDis: (conditions) => {
    const { rsvNo, grpCd } = conditions;
    // urlの定義
    const url = `/api/v1/interviews/${rsvNo}/groups/${grpCd}/results`;
    // 病歴取得API呼び出し
    return axios
      .get(url, {
        params: conditions,
        validateStatus: (status) => (status < 500),
      })
      .then((res) => {
        // 成功時は病歴取得成功アクションを呼び出す
        const { data = [] } = res;
        return { historyRslDisData: data };
      });
  },
  // 自覚症状検索
  getHistoryRslListJikaku: (conditions) => {
    const { rsvNo, grpCd } = conditions;
    // urlの定義
    const url = `/api/v1/interviews/${rsvNo}/groups/${grpCd}/results`;
    // 自覚症状取得API呼び出し
    return axios
      .get(url, {
        params: conditions,
        validateStatus: (status) => (status < 500),
      })
      .then((res) => {
        // 成功時は自覚症状取得成功アクションを呼び出す
        const { historyRslJikakuData = [] } = res.data;
        return { historyRslJikakuData };
      });
  },
  // 指定された予約番号の総合コメントを更新する
  getTotalJudCmt: (conditions) => {
    const { rsvno } = conditions;
    // 総合コメント取得
    // urlの定義
    const url = `/api/v1/consultations/${rsvno}/totalcomments`;
    // 総合コメント取得API呼び出し
    return axios
      .get(url, {
        params: conditions,
        validateStatus: (status) => (status < 500),
      })
      .then((res) => res.data);
  },
  // 指定された個人ＩＤの受診歴一覧を取得する
  GetConsultHistory: (conditions) => {
    const { rsvNo } = conditions;
    // 受診歴一覧取得
    // urlの定義
    const url = `/api/v1/interviews/${rsvNo}/histories`;
    // 受診歴一覧取得API呼び出し
    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => {
        // 成功時は総合コメント取得取得成功アクションを呼び出す
        const { data = [] } = res;
        return { consultHistoryData: data };
      });
  },
  // コースグループ取得
  GetCsGrp: (conditions) => {
    const { rsvNo } = conditions;
    // 受診歴一覧取得
    // urlの定義
    const url = `/api/v1/consultations/${rsvNo}/coursegroups`;
    // 受診歴一覧取得API呼び出し
    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => {
        // 成功時は総合コメント取得取得成功アクションを呼び出す
        const csGrpData = res.data;
        return { csGrpData };
      });
  },
  // 指定された予約番号のオーダ番号、送信日を取得する
  GetOrderNo: (conditions) => {
    const { rsvNo } = conditions;
    // 受診歴一覧取得
    // urlの定義
    const url = `/api/v1/interviews/${rsvNo}/orders`;
    // 受診歴一覧取得API呼び出し
    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => {
        // 成功時は総合コメント取得取得成功アクションを呼び出す
        const orderNoData = res.data;
        return { orderNoData };
      });
  },
  // 健診が終わった後受診者の個人IDを変更した場合、変更前のIDと変更後のIDを取得する
  GetChangePerId: (conditions) => {
    const { rsvNo } = conditions;
    // 受診歴一覧取得
    // urlの定義
    const url = `/api/v1/consultations/${rsvNo}/changeperid`;
    // 受診歴一覧取得API呼び出し
    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => {
        // 成功時は総合コメント取得成功アクションを呼び出す
        const peridData = res.data;
        return { peridData };
      });
  },
  // 指定検索条件の変更履歴を取得する
  getUpdateLogList: (conditions) => {
    const { rsvno } = conditions;
    // urlの定義
    const url = `/api/v1/interviews/${rsvno}/records`;
    // 指定検索条件の変更履歴を取得API呼び出し
    return axios
      .get(url, {
        params: conditions,
        // axios標準では404エラーも例外として扱われるため、500未満であれば正常となるよう変更
        // (アプリケーション規模が大きくなってきたら1ヶ所で定義するように変更したほうがよいかもしれない)
        validateStatus: (status) => (status < 500),
      })
      .then((res) => {
        // 成功時は指定検索条件の変更履歴を取得取得成功アクションを呼び出す
        const { totalcount = 0, data = [] } = res.data;
        return { totalCount: totalcount, data };
      });
  },
  // 指定検索条件の入院・外来歴を取得する
  getPatientHistory: (conditions) => {
    const { rsvno } = conditions;
    // urlの定義
    const url = `/api/v1/interviews/${rsvno}/patienthistories`;
    // 指定検索条件の変更履歴を取得API呼び出し
    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => res.data);
  },
  // 指定検索条件の病歴を取得する
  getDiseaseHistory: (conditions) => {
    const { rsvno } = conditions;
    // urlの定義
    const url = `/api/v1/interviews/${rsvno}/diseasehistories`;
    // 指定検索条件の変更履歴を取得API呼び出し
    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => res.data);
  },
  // 指定された予約番号の総合コメントを更新する
  updateTotalJudCmt: ({ params, data }) => {
    const { rsvno } = params;
    const method = 'PUT';
    // urlの定義
    const url = `/api/v1/consultations/${rsvno}/totalcomments`;

    return axios({
      method,
      url,
      data,
    })
      .then(() => ({}));
  },

  // eGFR(MDRD)計算結果を履歴として取得
  getMdrdHistory: (conditions) => {
    const { rsvno } = conditions;
    // urlの定義
    const url = `/api/v1/interviews/${rsvno}/results/egfr`;

    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => res.data);
  },
  // GFR(新しい日本人の推算式)計算結果を履歴として取得
  getNewGfrHistory: (conditions) => {
    const { rsvno } = conditions;
    // urlの定義
    const url = `/api/v1/interviews/${rsvno}/results/newgfr`;

    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => res.data);
  },
  // 判定の一覧を取得する
  getJudList: () => {
    // urlの定義
    const url = '/api/v1/judcodes';
    return axios
      .get(url)
      .then((res) => res.data);
  },
};

export default interviewService;
