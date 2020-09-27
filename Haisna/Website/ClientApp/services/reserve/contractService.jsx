import axios from 'axios';

const contractService = {
  // 指定の条件に該当するコースを取得する
  getContractCourseList: (payload) => {
    const { orgcd1, orgcd2 } = payload;

    const params = { ...payload };
    delete params.orgcd1;
    delete params.orgcd2;

    const url = `/api/v1/organizations/${orgcd1}/${orgcd2}/contracts`;
    return axios
      .get(url, {
        params,
        validateStatus: (status) => (status === 404 || status < 400),
      })
      .then((res) => res.data);
  },
  // 指定の条件に該当する受診区分を取得する
  getContractCslDivList: (payload) => {
    const { orgcd1, orgcd2 } = payload;

    const params = { ...payload };
    delete params.orgcd1;
    delete params.orgcd2;

    const url = `/api/v1/organizations/${orgcd1}/${orgcd2}/consultdivisions`;
    return axios
      .get(url, {
        params,
        validateStatus: (status) => (status === 404 || status < 400),
      })
      .then((res) => res.data);
  },
  // 指定の条件に該当する検査オプションを取得する
  getContractOptionsStatus: (payload) => {
    const { ctrptcd } = payload;

    const params = { ...payload };
    delete params.ctrptcd;

    const url = `/api/v1/contracts/${ctrptcd}/options/status`;
    return axios
      .get(url, {
        params,
        validateStatus: (status) => (status === 404 || status < 400),
      })
      .then(((res) => res.data));
  },
  // 指定条件に該当する検査項目の受信状態を取得する
  getContractOption: (payload) => {
    const { ctrptcd, optcd, optbranchno } = payload;

    const url = `/api/v1/contracts/${ctrptcd}/options/${optcd}/${optbranchno}`;
    return axios
      .get(url, {
        validateStatus: (status) => (status === 404 || status < 400),
      })
      .then((res) => res.data);
  },
  // 指定条件に該当する検査項目の受診状態を取得する
  getContractOptionItems: (payload) => {
    const { rsvno } = payload;

    const params = { ...payload };
    delete params.rsvno;

    const url = `/api/v1/consultations/${rsvno}/items`;
    return axios
      .get(url, {
        params,
        validateStatus: (status) => (status === 404 || status < 400),
      })
      .then((res) => res.data);
  },
};

export default contractService;
