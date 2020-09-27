import React from 'react';
import moment from 'moment';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';

import MessageBanner from '../../components/MessageBanner';
import GuideBase from '../../components/common/GuideBase';
import Table from '../../components/Table';

import { closeOtherIncomeSubGuide } from '../../modules/bill/billModule';

const Wrapper = styled.div`
  height: 300px;
  width: 900px;
  margin-top: 10px;
  overflow-y: auto;
`;

const SubTotal = styled.span`
  font-weight: bold;
  color: #FF0000;
`;

const Dmddate = styled.span`
  color: #666666;
`;

const subTotal = (rec) => {
  let total = 0;
  total = rec.price_all + rec.editprice_all + rec.taxprice_all + rec.edittax_all;
  return total;
};

const OtherIncomeSubGuide = (props) => {
  const { perBill, message, onSelected } = props;
  return (
    <GuideBase {...props} title="請求書番号選択" usePagination >
      <MessageBanner messages={message} />
      <Wrapper>
        <Table triped hover>
          <thead>
            <tr>
              <td>請求書No.</td>
              <td>請求書発生日</td>
              <td>　金額</td>
              <td>調整金額</td>
              <td>　税額</td>
              <td>調整税額</td>
              <td>小計</td>
              <td>未収額</td>
            </tr>
          </thead>
          <tbody>
            {perBill && perBill.map((item) => (
              <tr key={item.billseq}>
                <td>
                  <a
                    style={{ textDecoration: 'underline' }}
                    role="presentation"
                    onClick={() => (onSelected(item))}
                  >
                    {moment(item.dmddate).format('YYYYMMDD')}{`0000${item.billseq}`.slice(-5)}{item.branchno}
                  </a>
                </td>
                <td><Dmddate>{moment(item.dmddate).format('YYYY/MM/DD')}</Dmddate></td>
                <td>&#165;{item.price_all.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</td>
                <td>&#165;{item.editprice_all.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</td>
                <td>&#165;{item.taxprice_all.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</td>
                <td>&#165;{item.edittax_all.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</td>
                <td>&#165;{subTotal(item).toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</td>
                <td><strong><SubTotal>&#165;{subTotal(item).toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,')}</SubTotal></strong></td>
              </tr>
            ))}
          </tbody>
        </Table>
      </Wrapper>
    </GuideBase>
  );
};

OtherIncomeSubGuide.propTypes = {
  perBill: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  onSelected: PropTypes.func.isRequired,
};

const mapStateToProps = (state) => ({
  perBill: state.app.bill.bill.otherIncomeSubGuide.perBill,
  visible: state.app.bill.bill.otherIncomeSubGuide.visible,
  message: state.app.bill.bill.otherIncomeSubGuide.message,
});

const mapDispatchToProps = (dispatch) => ({
  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeOtherIncomeSubGuide());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(OtherIncomeSubGuide);
