import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Field, reduxForm, getFormValues } from 'redux-form';
import styled from 'styled-components';

import moment from 'moment';

import GuideBase from '../../components/common/GuideBase';
import Button from '../../components/control/Button';
import DropDown from '../../components/control/dropdown/DropDown';
import MessageBanner from '../../components/MessageBanner';
import BulletedLabel from '../../components/control/BulletedLabel';

import { getFriendsPerbillRequest, changeDisplayRow, clearPerBillInfo, closePerbillallincomeGuide } from '../../modules/bill/perBillModule';

import PerBillAllIncomeList from './PerBillAllIncomeList';

import RslConsult from './RslConsult';

import * as contants from '../../constants/common';

const Wrapper = styled.div`
  height: 550px;
  margin-top: 10px;
  overflow-y: auto;
`;

const formName = 'perBillAllIncomeGuide';

class PerBillAllIncomeGuide extends React.Component {
  constructor(props) {
    super(props);

    this.friendsDmdSet = this.friendsDmdSet.bind(this);
    this.clearPerBillInfo = this.clearPerBillInfo.bind(this);
    this.handleChangeRow = this.handleChangeRow.bind(this);
  }

  // 同伴者（お連れ様）の請求書情報を取得する
  friendsDmdSet(csldate, rsvno) {
    const { onFriends } = this.props;
    if (csldate != null && rsvno !== null) {
      onFriends(csldate, rsvno);
    }
  }

  // 請求書情報のクリア
  clearPerBillInfo(index) {
    const { onClearPerBillInfo } = this.props;

    onClearPerBillInfo(index);
  }

  gdePerBill() {
    // TODO
    // 個人請求書の検索画面呼び出し
  }

  perBillIncome() {
  // TODO
  // 統合確認画面表示
  }

  // 表示ボタンを押下
  handleChangeRow() {
    const { onChangeRow, formValues } = this.props;

    onChangeRow(formValues.dispCnt);
  }

  render() {
    const { rslConsultdata, disPerBillList, dispCnt, message } = this.props;

    // 行数選択リストの編集
    const dispInfoItems = [];
    let i = contants.DEFAULT_ROW;
    while (true) {
      // 現在の行数以上の行数を選択可能とする
      if (i >= dispCnt) {
        dispInfoItems.push({ value: i, name: `${i}枚` });
      }

      // 編集行数が表示行数を超えた場合は処理を終了する
      if (i > dispCnt) {
        break;
      }

      i += contants.INCREASE_COUNT;
    }

    return (
      <GuideBase {...this.props} title="まとめて入金" usePagination >
        <MessageBanner messages={message} />
        <Wrapper>
          <RslConsult data={rslConsultdata} />

          <div style={{ marginTop: '30px' }}>
            <BulletedLabel>まとめて入金する請求書を選択してください。</BulletedLabel>
            <a role="presentation" onClick={() => this.friendsDmdSet(moment(rslConsultdata.csldate).format('YYYY/MM/DD'), rslConsultdata.rsvno)} style={{ color: '#0000ff' }}>上記受診者のお連れ様請求書をセット</a>
            <Button style={{ marginLeft: '5px' }} onClick={() => this.perBillIncome()} value="確定" />
          </div>

          <div style={{ marginTop: '20px' }}>
            <PerBillAllIncomeList data={disPerBillList} lastkname={rslConsultdata.lastkname} firstkname={rslConsultdata.firstkname} gdePerBill={this.gdePerBill} onDelete={this.clearPerBillInfo} />
          </div>

          <div style={{ marginTop: '30px' }}>
            指定可能請求書を
            <Field name="dispCnt" component={DropDown} items={dispInfoItems} />
            <Button style={{ marginLeft: '10px' }} value="表示" onClick={() => this.handleChangeRow()} />
          </div>
        </Wrapper>
      </GuideBase>
    );
  }
}

const PerBillAllIncomeGuideForm = reduxForm({
  form: formName,
  enableReinitialize: true,
})(PerBillAllIncomeGuide);

// propTypesの定義
PerBillAllIncomeGuide.propTypes = {
  rsvno: PropTypes.number.isRequired,
  visible: PropTypes.bool.isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  refreshFlg: PropTypes.number.isRequired,
  rslConsultdata: PropTypes.shape().isRequired,
  disPerBillList: PropTypes.arrayOf(PropTypes.object).isRequired,
  dispCnt: PropTypes.number.isRequired,
  onClose: PropTypes.func.isRequired,
  onFriends: PropTypes.func.isRequired,
  onChangeRow: PropTypes.func.isRequired,
  onClearPerBillInfo: PropTypes.func.isRequired,
  formValues: PropTypes.shape(),
};

PerBillAllIncomeGuide.defaultProps = {
  formValues: { dispCnt: contants.DEFAULT_ROW },
};

// componentのプロパティとして紐付けるstate(状態)の定義
const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    rsvno: state.app.bill.perBill.perbillallincome.rsvno,
    visible: state.app.bill.perBill.perbillallincome.visible,
    message: state.app.bill.perBill.perbillallincome.message,
    rslConsultdata: state.app.bill.perBill.perbillallincome.rslConsultdata,
    refreshFlg: state.app.bill.perBill.perbillallincome.refreshFlg,
    disPerBillList: state.app.bill.perBill.perbillallincome.disPerBillList,
    dispCnt: state.app.bill.perBill.perbillallincome.dispCnt,
  };
};

// componentのプロパティとして紐付けるアクション(action)の定義
const mapDispatchToProps = (dispatch) => ({
  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closePerbillallincomeGuide());
  },
  // 同伴者（お連れ様）の請求書情報を取得
  onFriends: (csldate, rsvno) => {
    dispatch(getFriendsPerbillRequest({ csldate: [csldate], rsvno: [rsvno] }));
  },
  // 請求書行の表示しなおし
  onChangeRow: (dispCnt) => {
    dispatch(changeDisplayRow({ dispCnt }));
  },
  // 請求書情報のクリア
  onClearPerBillInfo: (index) => {
    dispatch(clearPerBillInfo({ index }));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(PerBillAllIncomeGuideForm);
