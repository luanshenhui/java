import axios from 'axios';

const judCmtStcService = {
  getAdviceCommentList: (params) => {
    const url = '/api/v1/judgescomments';
    return axios
      .get(url, {
        params,
        validateStatus: (status) => (status < 500),
      })
      .then((res) => res.data || []);
  },
};

export default judCmtStcService;
