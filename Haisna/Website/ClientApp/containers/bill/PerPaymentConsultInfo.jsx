import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import { Link } from 'react-router-dom';
import moment from 'moment';

import Table from '../../components/Table';

const Color = styled.span`
  font-weight: bold;
  color: #FF0000;
`;

const PerPaymentConsultInfo = ({ data, delDsp, rsvno, onOpenPerBillIncomeGuide }) => {
  let dataCount = 0;
  let perBillTotal = 0;
  let perPayTotal = 0;
  let totalFlg = 0;
  let delCount = 0;
  const setTotalTable = [];

  if (data != null) {
    dataCount = data.length;
  }

  // ToDo
  for (let i = 0; i < dataCount; i += 1) {
    // 取消し伝票カウントする。
    if (data[i].delflg === 1) {
      delCount += 1;
    }
    // 未入金の請求書をカウントする。（ohterIncomeInfoのパラメータ）
    // ToDo
  }

  const consultInfo = [];
  // 個人請求書情報の編集
  for (let j = 0; j < dataCount; j += 1) {
    if (delDsp === 1 || (delDsp !== 1 && data[j].delflg !== 1)) {
      // 取消し伝票表示あり時の請求書合計表示
      if (delDsp === 1 && data[j].delflg === 1 && totalFlg === 0 && data.length > delCount) {
        setTotalTable.push(<tr><td /><td>合計</td><td colSpan="4" /><td>{perBillTotal}</td><td>{perPayTotal}</td><td colSpan="3" /></tr>);
        totalFlg = 1;
        perBillTotal = 0;
        perPayTotal = 0;
      }

      consultInfo.push({
        key: null,
        requestNo: null,
        dmdDate: null,
        price: null,
        editPrice: null,
        taxPrice: null,
        editTax: null,
        subTotal: null,
        perPayTotal: null,
        paymentInfo: null,
        refund: null,
        billSeq: null,
        branchNo: null,
      });

      consultInfo[j].key = j;
      consultInfo[j].requestNo = moment(data[j].dmddate).format('YYYYMMDD') + `0000${data[j].billseq}`.slice(-5) + data[j].branchno;
      consultInfo[j].dmdDate = moment(data[j].dmddate).format('YYYY/MM/DD');
      consultInfo[j].price = data[j].price_all;
      consultInfo[j].editPrice = data[j].editprice_all;
      consultInfo[j].taxPrice = data[j].taxprice_all;
      consultInfo[j].editTax = data[j].edittax_all;
      consultInfo[j].subTotal = data[j].price_all + data[j].editprice_all + data[j].taxprice_all + data[j].edittax_all;
      // 入金情報あり？
      if (data[j].paymentdate != null) {
        consultInfo[j].perPayTotal = 0;
      } else {
        if (data[j].branchno === 0) {
          perPayTotal += consultInfo[j].subTotal;
        }
        // ToDo Color
        consultInfo[j].perPayTotal = data[j].branchno === 0 ? consultInfo[j].subTotal : 0;
      }
      // 入金処理
      if (data[j].branchno === 0) {
        consultInfo[j].paymentInfo = '入金情報';
        consultInfo[j].refund = null;
      } else {
        consultInfo[j].paymentInfo = '返金情報';
        if (data[j].paymentdate != null) {
          consultInfo[j].refund = '済';
        } else {
          consultInfo[j].refund = null;
        }
      }
      perBillTotal += consultInfo[j].subTotal;
      consultInfo[j].billSeq = data[j].billseq;
      consultInfo[j].branchNo = data[j].branchno;
    }
  }

  return (
    <Table style={{ width: '60%' }}>
      <thead>
        <tr>
          <th style={{ textAlign: 'left' }}>請求書No.</th>
          <th>請求書発生日</th>
          <th style={{ textAlign: 'right' }}>金額</th>
          <th style={{ textAlign: 'right' }}>調整金額</th>
          <th style={{ textAlign: 'right' }}>税額</th>
          <th style={{ textAlign: 'right' }}>調整税額</th>
          <th style={{ textAlign: 'right' }}>小計</th>
          <th style={{ textAlign: 'right' }}>未収額</th>
          <th style={{ textAlign: 'right' }}>入金処理</th>
          <th style={{ textAlign: 'right' }}>返金</th>
          <th style={{ textAlign: 'right' }}>印刷</th>
        </tr>
      </thead>
      {setTotalTable}
      <tbody>
        {consultInfo && consultInfo.map((rec) => (
          <tr key={rec.key}>
            <td
              style={{ textAlign: 'left' }}
            >
              <Link to={`/contents/reserve/perBillInfo/${moment(rec.dmdDate).format('YYYY-MM-DD')}/${rec.billSeq}/${rec.branchNo}/${rsvno}`}>{rec.requestNo}</Link>
            </td>
            <td>{rec.dmdDate}</td>
            <td style={{ textAlign: 'right' }}>&#165;{rec.price.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</td>
            <td style={{ textAlign: 'right' }}>&#165;{rec.editPrice.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</td>
            <td style={{ textAlign: 'right' }}>&#165;{rec.taxPrice.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</td>
            <td style={{ textAlign: 'right' }}>&#165;{rec.editTax.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</td>
            <td style={{ textAlign: 'right' }}><strong>&#165;{rec.subTotal.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</strong></td>
            <td style={{ textAlign: 'right' }}><Color>&#165;{rec.perPayTotal.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</Color></td>
            <td style={{ textAlign: 'right' }}>
              <a
                href="#"
                onClick={() => { onOpenPerBillIncomeGuide(rsvno, rec.dmdDate, rec.billSeq, rec.branchNo); }}
                style={{ color: '#0000ff' }}
              >
                {rec.paymentInfo}
              </a>
            </td>
            <td style={{ textAlign: 'center' }}><Link to={`/contents/bill/payment/info/${rec.paymentdate}/`}>{rec.refund}</Link></td>
            <td style={{ textAlign: 'right' }}><Link to={`/contents/reserve/prtPerBill/${moment(rec.dmdDate).format('YYYY-MM-DD')}/${rec.billSeq}/${rec.branchNo}/0`}>印刷</Link></td>
          </tr>
        ))}
        {((data.length > delCount) || (delDsp === 1 && delCount > 0)) &&
        <tr>
          <td />
          <td>合計</td>
          <td colSpan="4" />
          <td style={{ textAlign: 'right' }}><strong>&#165;{perBillTotal.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</strong></td>
          <td style={{ textAlign: 'right' }}><strong>&#165;{perBillTotal.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</strong></td>
          <td colSpan="3" />
        </tr>
        }
      </tbody>
    </Table>
  );
};

PerPaymentConsultInfo.propTypes = {
  delDsp: PropTypes.number.isRequired,
  rsvno: PropTypes.number.isRequired,
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  onOpenPerBillIncomeGuide: PropTypes.func.isRequired,
};

export default PerPaymentConsultInfo;

