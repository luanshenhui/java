import React from 'react';
import moment from 'moment';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Field, reduxForm, getFormValues } from 'redux-form';
import * as contants from '../../constants/common';

import { getFriendsPerbillRequest, getPersonLukesRequest, changeDisplayRow, clearPerBillInfo, openGdePerBillGuideRequest } from '../../modules/bill/perBillModule';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import Label from '../../components/control/Label';
import BulletedLabel from '../../components/control/BulletedLabel';
import DropDown from '../../components/control/dropdown/DropDown';
import Button from '../../components/control/Button';
import PerBillCsl from './PerBillCsl';
import MergePerBillList from './MergePerBillList';
import GdePerBillList from './GdePerBillList';
import MoneyFormat from './MoneyFormat';

const formName = 'mergePerBill1Form';

class MergePerBillGuide1 extends React.Component {
  constructor(props) {
    super(props);

    this.friendsDmdSet = this.friendsDmdSet.bind(this);
    this.clearPerBillInfo = this.clearPerBillInfo.bind(this);
    this.handleChangeRow = this.handleChangeRow.bind(this);
    this.gdePerBill = this.gdePerBill.bind(this);
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

  gdePerBill(index, sortKind, sortMode, paymentflg, delDisp, key, startDmdDate, endDmdDate, billSeq, branchNo) {
    // 個人請求書の検索画面呼び出し
    const { onGdePerBill } = this.props;
    onGdePerBill({ index, sortKind, sortMode, paymentflg, delDisp, key, startDmdDate, endDmdDate, billSeq, branchNo });
  }

  // 請求統合処理画面表示
  callmergePerBill2(disPerBillList) {
    const { onCallmergePerBill2, formValues } = this.props;
    onCallmergePerBill2(disPerBillList, formValues.dispCnt);
  }

  // 表示ボタンを押下
  handleChangeRow() {
    const { onChangeRow, formValues } = this.props;

    onChangeRow(parseInt(formValues.dispCnt, 10));
  }

  render() {
    const { dispCnt, dmdDate, requestNo, priceTotal, taxTotal, perBillCsl, disPerBillList, billSeq, branchNo } = this.props;
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
      <div>
        <FieldGroup itemWidth={100}>
          <FieldSet>
            <FieldItem>請求発生日</FieldItem>
            <Label>{dmdDate}</Label>
          </FieldSet>
          <FieldSet>
            <FieldItem>請求書No</FieldItem>
            <Label>{requestNo}</Label>
          </FieldSet>
          <FieldSet>
            <FieldItem>請求金額</FieldItem>
            <Label>
              <strong><MoneyFormat money={priceTotal} />
              </strong>{'（内　消費税'}<MoneyFormat money={taxTotal} />{'）'}
            </Label>
          </FieldSet>
        </FieldGroup>
        <br />
        <PerBillCsl data={perBillCsl[0]} />
        <div style={{ marginTop: '30px' }}>
          <BulletedLabel>統合したい請求書を選択してください。</BulletedLabel>
          <a
            href="#"
            onClick={() => this.friendsDmdSet(moment(perBillCsl[0] && perBillCsl[0].csldate).format('YYYY/MM/DD'), perBillCsl[0] && perBillCsl[0].rsvno)}
            style={{ color: '#0000ff' }}
          >
            上記受診者のお連れ様請求書をセット
          </a>
          <Button style={{ marginLeft: '5px' }} onClick={() => this.callmergePerBill2(disPerBillList)} value="確定" />
        </div>

        <div style={{ marginTop: '20px' }}>
          <MergePerBillList
            data={disPerBillList}
            dmdDate={dmdDate}
            billSeq={billSeq}
            branchNo={branchNo}
            gdePerBill={this.gdePerBill}
            onDelete={this.clearPerBillInfo}
          />
        </div>
        <GdePerBillList />
        <div style={{ marginTop: '30px' }}>
          指定可能請求書を
          <Field name="dispCnt" component={DropDown} items={dispInfoItems} />
          <Button style={{ marginLeft: '10px' }} value="表示" onClick={() => this.handleChangeRow()} />
        </div>
      </div>
    );
  }
}

const MergePerBillGuide1Form = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  enableReinitialize: true,
})(MergePerBillGuide1);

// propTypesの定義
MergePerBillGuide1.propTypes = {
  // stateと紐付けされた項目
  perBillCsl: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  disPerBillList: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  dispCnt: PropTypes.number.isRequired,
  dmdDate: PropTypes.string.isRequired,
  requestNo: PropTypes.string.isRequired,
  priceTotal: PropTypes.number.isRequired,
  taxTotal: PropTypes.number.isRequired,
  onClearPerBillInfo: PropTypes.func.isRequired,
  onChangeRow: PropTypes.func.isRequired,
  onFriends: PropTypes.func.isRequired,
  onCallmergePerBill2: PropTypes.func.isRequired,
  onGdePerBill: PropTypes.func.isRequired,
  billSeq: PropTypes.string.isRequired,
  branchNo: PropTypes.string.isRequired,
  formValues: PropTypes.shape(),
};

MergePerBillGuide1.defaultProps = {
  formValues: { dispCnt: contants.DEFAULT_ROW },
};

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    perBillCsl: state.app.bill.perBill.mergeGuide.perBillCsl,
    dmdDate: state.app.bill.perBill.mergeGuide.dmdDate,
    disPerBillList: state.app.bill.perBill.mergeGuide.disPerBillList,
    requestNo: state.app.bill.perBill.mergeGuide.requestNo,
    priceTotal: state.app.bill.perBill.mergeGuide.priceTotal,
    taxTotal: state.app.bill.perBill.mergeGuide.taxTotal,
    dispCnt: state.app.bill.perBill.mergeGuide.dispCnt,
    billSeq: state.app.bill.perBill.mergeGuide.billSeq,
    branchNo: state.app.bill.perBill.mergeGuide.branchNo,
    // 可視状態
    visible: state.app.bill.perBill.mergeGuide.visible,
    flg: state.app.bill.perBill.mergeGuide.flg,
  };
};

// componentのプロパティとして紐付けるアクション(action)の定義
const mapDispatchToProps = (dispatch, props) => ({
  // 同伴者（お連れ様）の請求書情報を取得
  onFriends: (csldate, rsvno) => {
    dispatch(getFriendsPerbillRequest({ csldate: [csldate], rsvno: [rsvno], formName }));
  },

  // 請求書行の表示しなおし
  onChangeRow: (dispCnt) => {
    dispatch(changeDisplayRow({ dispCnt, formName }));
  },

  // 請求書情報のクリア
  onClearPerBillInfo: (index) => {
    dispatch(clearPerBillInfo({ index, formName }));
  },

  // 統合確認画面表示
  onCallmergePerBill2: (disPerBillList, dispCnt) => {
    dispatch(getPersonLukesRequest({ disPerBillList, dispCnt }));
    props.onNext();
  },

  // 個人請求書の検索画面表示
  onGdePerBill: (params) => {
    dispatch(openGdePerBillGuideRequest({ params }));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(MergePerBillGuide1Form);
