import React from 'react';
import PropTypes from 'prop-types';
import Table from '../../components/Table';

// 性別名称設定
const updGender = (data) => {
  const resUpdGender = [];
  let updDispGenderName = '';
  switch (data) {
    case 1:
      updDispGenderName = '男性';
      break;
    case 2:
      updDispGenderName = '女性';
      break;
    case 3:
      updDispGenderName = '共通';
      break;
    default:
      updDispGenderName = '？？他';
      break;
  }
  resUpdGender.push(updDispGenderName);
  return resUpdGender;
};

const MngInfo = ({ data, border }) => {
  const dispitemcd = [];
  const dispitemname = [];
  const dispgendername = [];
  const disppercentL = [];
  const disppercentH = [];
  const res = [];
  const itemcd = [];
  const itemname = [];
  const seq = [];
  const suffix = [];
  const resultcount = [];
  const percentH = [];
  const percentL = [];
  const valH = [];
  const valL = [];
  const valS = [];
  const gender = [];
  let prevseq = 0;
  let count = 0;
  let itemH = null;
  let itemL = null;

  while (count < data.length && data.length > 0) {
    itemcd[count] = data[count].itemcd;
    itemname[count] = data[count].itemname;
    seq[count] = data[count].seq;
    suffix[count] = data[count].suffix;
    resultcount[count] = data[count].resultcount;
    percentH[count] = data[count].percent_h;
    percentL[count] = data[count].percent_l;
    valH[count] = data[count].val_h;
    valL[count] = data[count].val_l;
    valS[count] = data[count].val_s;
    gender[count] = data[count].gender;
    dispgendername[count] = updGender(gender[count]);
    itemH = percentH[count].toString();
    itemL = percentL[count].toString();
    if ((itemH.includes('.')) === false) {
      disppercentH[count] = `${percentH[count]}.0%`;
    } else {
      disppercentH[count] = `${percentH[count]}%`;
    }
    if ((itemL.includes('.')) === false) {
      disppercentL[count] = `${percentL[count]}.0%`;
    } else {
      disppercentL[count] = `${percentL[count]}%`;
    }
    count += 1;
  }

  for (let i = 0; i < data.length; i += 1) {
    let blnboldmode = false;
    if (seq[i] !== prevseq) {
      dispitemcd[i] = `${itemcd[i]}-${suffix[i]}`;
      dispitemname[i] = itemname[i];
    } else {
      dispitemcd[i] = null;
      dispitemname[i] = null;
    }
    if (!Number.isNaN(parseFloat(border))) {
      if (parseFloat(percentL[i]) >= parseFloat(border)) {
        disppercentL[i] = <strong>{disppercentL[i]}</strong>;
        blnboldmode = true;
      }
      if (parseFloat(percentH[i]) >= parseFloat(border)) {
        disppercentH[i] = <strong>{disppercentH[i]}</strong>;
        blnboldmode = true;
      }
      if (blnboldmode) {
        dispitemcd[i] = <strong>{dispitemcd[i]}</strong>;
        dispitemname[i] = <strong>{dispitemname[i]}</strong>;
        dispgendername[i] = <strong>{updGender(gender[i])}</strong>;
      } else {
        dispitemcd[i] = <span style={{ color: '#999999' }}>{dispitemcd[i]}</span>;
        dispitemname[i] = <span style={{ color: '#999999' }}>{dispitemname[i]}</span>;
        dispgendername[i] = <span style={{ color: '#999999' }}>{updGender(gender[i])}</span>;
      }
    }

    const td1 = <td style={{ whiteSpace: 'pre' }}>{dispitemcd[i]}</td>;
    const td2 = <td style={{ whiteSpace: 'pre' }}>{dispitemname[i]}</td>;
    const td3 = <td style={{ whiteSpace: 'pre' }}>{dispgendername[i]}</td>;
    const td4 = <td align="right" style={{ whiteSpace: 'pre' }}>{resultcount[i]}</td>;
    const td5 = <td bgcolor="#FFFFFF" style={{ border: '0px' }}>&nbsp;</td>;
    const td6 = <td align="right" bgcolor="#E6E6FA" style={{ whiteSpace: 'pre' }}>{valL[i]}</td>;
    const td7 = <td align="right" style={{ whiteSpace: 'pre' }}>{valS[i]}</td>;
    const td8 = <td align="right" bgcolor="#FFC0CB" style={{ whiteSpace: 'pre' }}>{valH[i]}</td>;
    const td9 = <td bgcolor="#FFFFFF" style={{ border: '0px' }}>&nbsp;</td>;
    const td10 = <td align="right" bgcolor="#E6E6FA" style={{ whiteSpace: 'pre' }}>{disppercentL[i]}</td>;
    const td11 = <td align="right" bgcolor="#FFC0CB" style={{ whiteSpace: 'pre' }}>{disppercentH[i]}</td>;

    res.push(<tr style={{ background: '#eeeeee' }} key={i}>{td1}{td2}{td3}{td4}{td5}{td6}{td7}{td8}{td9}{td10}{td11}</tr>);

    // 現レコードのオプションコードを退避
    prevseq = seq[i];
  }

  return res;
};

const MngaccuracyInfoBody = ({ data, border }) => (
  <Table style={{ width: 850 }}>
    <thead>
      <tr bgcolor="silver">
        <td rowSpan="2" style={{ width: 120 }}>検査項目コード</td>
        <td rowSpan="2" style={{ width: 140 }}>検査項目名</td>
        <td rowSpan="2" style={{ width: 50 }}>性別</td>
        <td rowSpan="2" style={{ width: 110 }}>有効検査結果数</td>
        <td bgcolor="#FFFFFF" rowSpan="2" style={{ width: 5 }}>&nbsp;</td>
        <td colSpan="3" align="center" style={{ width: 150 }}>検査結果数</td>
        <td bgcolor="#FFFFFF" rowSpan="2" style={{ width: 5 }}>&nbsp;</td>
        <td colSpan="3" align="center" style={{ width: 270 }}>比率</td>
      </tr>
      <tr bgcolor="silver">
        <td style={{ width: 90 }}>基準外（低）</td>
        <td style={{ width: 60 }}>基準内</td>
        <td style={{ width: 90 }}>基準外（高）</td>
        <td style={{ width: 90 }}>基準外（低）</td>
        <td style={{ width: 90 }}>基準外（高）</td>
      </tr>
    </thead>
    <tbody>
      <MngInfo data={data} border={border} />
    </tbody>
  </Table>
);
// propTypesの定義
MngaccuracyInfoBody.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  border: PropTypes.string,
};

// defaultPropsの定義
MngaccuracyInfoBody.defaultProps = {
  border: null,
};

export default MngaccuracyInfoBody;
