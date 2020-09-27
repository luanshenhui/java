import axios from 'axios';


const paymentImportCsvService = {
  // 入金情報の作成
  importCsv: (obj) => {
    const formData = new FormData();
    const config = {
      headers: { 'content-type': 'multipart/form-data' },
    };
    formData.append('file', obj.files);
    if (obj.startPos !== undefined) {
      formData.append('startPos', obj.startPos);
    }
    const url = '/api/v1/payments/UploadFiles';
    return axios
      .post(url, formData, config)
      .then((res) => (res));
  },

};

export default paymentImportCsvService;
