import axios from 'axios';

const judClassService = {
  getJudClass: (judClassCd) => {
    const url = `/api/v1/judclasses/${judClassCd}`;
    return axios
      .get(url, {
        validateStatus: (status) => (status < 500),
      })
      .then((res) => {
        const { data } = res;
        return data;
      });
  },
};

export default judClassService;
