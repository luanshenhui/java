import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import { Link } from 'react-router-dom';
import moment from 'moment';

import * as contants from '../../constants/common';
import Table from '../../components/Table';

const Color = styled.span`
  font-weight: bold;
  color: #FF0000;
`;

const PerPaymentConsultTotal = ({ data, totalData, rsvno, onOpenEditPerBillGuide }) => {
  // 合計計算
  let priceTotal = 0;
  let editPriceTotal = 0;
  let taxTotal = 0;
  let editTaxTotal = 0;
  let total = 0;
  let breakOrgCd1 = '';
  let breakOrgCd2 = '';
  if (data.length > 0) {
    breakOrgCd1 = data[0].orgcd1;
    breakOrgCd2 = data[0].orgcd2;
  }
  let header = 0;
  let subCount;
  const setTotalTable = [];

  for (let i = 0; i < totalData.length; i += 1) {
    priceTotal += totalData[i].subprice;
    editPriceTotal += totalData[i].subeditprice;
    taxTotal += totalData[i].subtaxprice;
    editTaxTotal += totalData[i].subedittax;
    total += totalData[i].sublinetotal;
  }

  const consultInfoTotal = [];
  consultInfoTotal.push({
    key: null,
    bear: null,
    requestNam: null,
    price: null,
    editPrice: null,
    taxPrice: null,
    editTax: null,
    subTotal: null,
    omitTax: null,
    seq: null,
    setCode: null,
    requestNum: null,
    unAmount: null,
  });

  // 個人負担請求書情報の編集
  for (let i = 0; i < data.length; i += 1) {
    // 負担元の最後に小計を表示する。
    if ((breakOrgCd1 !== data[i].orgcd1) || (breakOrgCd2 !== data[i].orgcd2)) {
      for (let recode = 0; recode < totalData.length; recode += 1) {
        if (breakOrgCd1 === totalData[recode].suborgcd1 && breakOrgCd2 === totalData[recode].suborgcd2) {
          subCount = recode;
          break;
        }
      }
      setTotalTable.push(<tr><td /><td>小計</td>);
      setTotalTable.push(<td style={{ textAlign: 'right' }}>&#165;{totalData[subCount].subprice.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</td>);
      setTotalTable.push(<td style={{ textAlign: 'right' }}>&#165;{totalData[subCount].subeditprice.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</td>);
      setTotalTable.push(<td style={{ textAlign: 'right' }}>&#165;{totalData[subCount].subtaxprice.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</td>);
      setTotalTable.push(<td style={{ textAlign: 'right' }}>&#165;{totalData[subCount].subedittax.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</td>
      setTotalTable.push(<td style={{ textAlign: 'right' }}>&#165;{totalData[subCount].sublinetotal.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</td><td colSpan="5" />);
      setTotalTable.push(</tr>);
      // ブレイク用変数、再セット
      breakOrgCd1 = data[i].orgcd1;
      breakOrgCd2 = data[i].orgcd2;
    }
    if ((data[i].orgcd1 !== contants.ORGCD1_PERSON || data[i].orgcd2 !== contants.ORGCD2_PERSON) && header === 0) {
      header = 1;
      setTotalTable.push(<tr><th>●団体負担金額情報</th></tr>);
      setTotalTable.push(<tr>);
      setTotalTable.push(<th>負担元</th>);
      setTotalTable.push(<th>請求明細名</th>);
      setTotalTable.push(<th style={{ textAlign: 'right' }}>　金額</th>);
      setTotalTable.push(<th style={{ textAlign: 'right' }}>調整金額</th>);
      setTotalTable.push(<th style={{ textAlign: 'right' }}>　税額</th>);
      setTotalTable.push(<th style={{ textAlign: 'right' }}>調整税額</th>);
      setTotalTable.push(<th style={{ textAlign: 'right' }}>小計</th>);
      setTotalTable.push(<th style={{ textAlign: 'right' }} />);
      setTotalTable.push(<th style={{ textAlign: 'right' }}>SEQ</th>);
      setTotalTable.push(<th style={{ textAlign: 'right' }}>セットコード</th>);
      setTotalTable.push(<th style={{ textAlign: 'right' }}>請求書No.</th>);
      setTotalTable.push(</tr>);
    }
  }

  const lineName = (rec, index) => {
    let res;
    // 負担元が個人の場合と領収書印刷済？
    if (rec.orgcd1 === contants.ORGCD1_PERSON && rec.orgcd2 === contants.ORGCD2_PERSON && rec.printdate !== null) {
      res = rec.linename;
    // セット外コード？
    } else if (rec.orgcd1 === contants.ORGCD1_PERSON && rec.orgcd2 === contants.ORGCD2_PERSON && rec.otherlinedivcd !== null) {
      res = <a href="#" onClick={() => { onOpenEditPerBillGuide(rsvno, rec.price, rec.editprice, rec.taxprice, rec.edittax, index, 2); }} style={{ color: '#0000ff' }}>{rec.linename}</a>;
    } else {
      res = <a href="#" onClick={() => { onOpenEditPerBillGuide(rsvno, rec.price, rec.editprice, rec.taxprice, rec.edittax, index, 1); }} style={{ color: '#0000ff' }}>{rec.linename}</a>;
    }
    return res;
  };

  const unAmount = (rec) => {
    let res = '';
    if (rec.orgcd1 === contants.ORGCD1_PERSON && rec.orgcd2 === contants.ORGCD2_PERSON) {
      if (rec.paymentdate === null || rec.paymentseq === null) {
        res = '未収';
      }
    }
    return res;
  };

  let count = 0;
  for (let recode = 0; recode < totalData.length; recode += 1) {
    if (breakOrgCd1 === totalData[recode].suborgcd1 && breakOrgCd2 === totalData[recode].suborgcd2) {
      count = recode;
      break;
    }
  }
  return (
    <Table>
      <thead>
        <tr>
          <th>負担元</th>
          <th>請求明細名</th>
          <th style={{ textAlign: 'right' }}>　金額</th>
          <th style={{ textAlign: 'right' }}>調整金額</th>
          <th style={{ textAlign: 'right' }}>　税額</th>
          <th style={{ textAlign: 'right' }}>調整税額</th>
          <th style={{ textAlign: 'right' }}>小計</th>
          <th style={{ textAlign: 'right' }}>税免除</th>
          <th style={{ textAlign: 'right' }}>SEQ</th>
          <th style={{ textAlign: 'right' }}>セットコード</th>
          <th style={{ textAlign: 'right' }}>請求書No.</th>
          <th style={{ textAlign: 'right' }}>未収額</th>
        </tr>
        {setTotalTable}
      </thead>
      <tbody>
        {data && data.map((rec, index) => (
          <tr key={rec.priceseq}>
            <td>{rec.orgcd1}-{rec.orgcd2}：{rec.orgname}</td>
            <td>{lineName(rec, index)}</td>
            <td style={{ textAlign: 'right' }}>&#165;{rec.price.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</td>
            <td style={{ textAlign: 'right' }}>&#165;{rec.editprice.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</td>
            <td style={{ textAlign: 'right' }}>&#165;{rec.taxprice.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</td>
            <td style={{ textAlign: 'right' }}>&#165;{rec.edittax.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</td>
            <td style={{ textAlign: 'right' }}>&#165;{rec.linetotal.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</td>
            <td style={{ textAlign: 'right' }}>{(rec.orgcd1 === contants.ORGCD1_PERSON && rec.orgcd2 === contants.ORGCD2_PERSON && rec.omittaxflg === 1) ? '○' : ''}</td>
            <td style={{ textAlign: 'right' }}>{rec.priceseq}</td>
            {rec.optcd !== null ?
              <td style={{ textAlign: 'right' }}>{rec.optcd}-{rec.optbranchno}</td>
              : <td />
            }
            {(rec.dmddate !== null && rec.billseq !== null && rec.branchno !== null) ?
              <td
                style={{ textAlign: 'right' }}
              >
                <Link
                  to={`/contents/reserve/perBillInfo/${moment(rec.dmddate).format('YYYY-MM-DD')}/${rec.billseq}/${rec.branchno}/${rsvno}`}
                >
                  {moment(rec.dmddate).format('YYYYMMDD')}{`0000${rec.billseq}`.slice(-5)}{rec.branchno}
                </Link>
              </td>
              : <td />
            }
            <td style={{ textAlign: 'right' }}><Color>{unAmount(rec)}</Color></td>
          </tr>
        ))}
        <tr>
          <td />
          <td>小計</td>
          <td style={{ textAlign: 'right' }}>&#165;{totalData.length > 0 && totalData[count].subprice.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</td>
          <td style={{ textAlign: 'right' }}>&#165;{totalData.length > 0 && totalData[count].subeditprice.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</td>
          <td style={{ textAlign: 'right' }}>&#165;{totalData.length > 0 && totalData[count].subtaxprice.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</td>
          <td style={{ textAlign: 'right' }}>&#165;{totalData.length > 0 && totalData[count].subedittax.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</td>
          <td style={{ textAlign: 'right' }}>&#165;{totalData.length > 0 && totalData[count].sublinetotal.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</td>
          <td colSpan="5" />
        </tr>
        <tr>
          <td />
          <td>合計</td>
          <td style={{ textAlign: 'right' }}><strong>&#165;{priceTotal.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</strong></td>
          <td style={{ textAlign: 'right' }}><strong>&#165;{editPriceTotal.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</strong></td>
          <td style={{ textAlign: 'right' }}><strong>&#165;{taxTotal.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</strong></td>
          <td style={{ textAlign: 'right' }}><strong>&#165;{editTaxTotal.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</strong></td>
          <td style={{ textAlign: 'right' }}><strong>&#165;{total.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</strong></td>
          <td colSpan="5" />
        </tr>
      </tbody>
    </Table>
  );
};

PerPaymentConsultTotal.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  totalData: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  onOpenEditPerBillGuide: PropTypes.func.isRequired,
  rsvno: PropTypes.string.isRequired,
};

export default PerPaymentConsultTotal;
