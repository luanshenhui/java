import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import { Field, reduxForm, getFormValues } from 'redux-form';
import { connect } from 'react-redux';

import MessageBanner from '../../components/MessageBanner';
import * as contants from '../../constants/common';
import { getPaymentRequest, openCreatePerBillGuideRequest, registerDelDspRequest, chgCheckvalue } from '../../modules/bill/demandModule';
import { openOtherIncomeInfoGuideRequest } from '../../modules/bill/billModule';
import { openEditPerBillGuideRequest, openPerbillOptionGuideRequest, openPerbillallincomeGuide, openPerBillIncomeGuide } from '../../modules/bill/perBillModule';
import { FieldValue } from '../../components/Field';
import PageLayout from '../../layouts/PageLayout';
import CheckBox from '../../components/control/CheckBox';
import SectionBar from '../../components/SectionBar';
import Button from '../../components/control/Button';
import PerPaymentListBody from './PerPaymentListBody';
import PerPaymentConsultInfo from './PerPaymentConsultInfo';
import PerPaymentConsultTotal from './PerPaymentConsultTotal';
import PerCloseMngInfoList from './PerCloseMngInfoList';
import PerPaymentListHeader from './PerPaymentListHeader';
import CreatePerBillGuide from './CreatePerBillGuide';
import EditPerBillGuide1 from './EditPerBillGuide1';
import EditPerBillGuide2 from './EditPerBillGuide2';
import OtherIncomeInfoGuideForm from './OtherIncomeInfoGuideForm';
import PerBillOptionGuideForm from './PerBillOptionGuideForm';
import PerBillAllIncomeGuide from './PerBillAllIncomeGuide';
import PerBillIncomeGuide from './PerBillIncomeGuide';

const formName = 'perPaymentList';

const Color = styled.span`
  font-weight: bold;
  color: #ff6600;
`;

class PerPaymentList extends React.Component {
  constructor(props) {
    super(props);
    this.handleOmitTaxAct = this.handleOmitTaxAct.bind(this);
    this.handleDisplay = this.handleDisplay.bind(this);
    const { match } = this.props;
    this.rsvno = match.params.rsvno;
  }

  componentDidMount() {
    const { onLoad, match } = this.props;
    onLoad(match.params.rsvno);
  }

  // 消費税免除処理
  handleOmitTaxAct() {
    const { onDelDsp, match, formValues } = this.props;
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm('個人負担金額の消費税を一括で免除します。よろしいですか？')) {
      return;
    }
    onDelDsp(formValues, match.params);
  }

  handleDisplay() {
    const { formValues, onCheckboxChg } = this.props;
    onCheckboxChg(formValues.delDsp, this.rsvno);
  }

  render() {
    const { delDsp, message, paymentInfo, perCloseMngInfo, paymentList, paymentConsultInfo, paymentConsultTotal,
      consultmTotal, onOpenPerBillGuide, onOpenPerBillAllIncomeGuide, onOpenOtherIncomeInfoGuide,
      onOpenPerbillOptionGuide, onOpenEditPerBillGuide, onOpenPerBillIncomeGuide } = this.props;
    let perCount = 0;
    let paymentConsultTotalCount = 0;
    let billCount = 0;
    let reqDmdDate = '';
    let reqBillSeq = null;
    let reqBranchNo = null;
    if (paymentConsultTotal != null) {
      paymentConsultTotalCount = paymentConsultTotal.length;
    }
    for (let i = 0; i < paymentConsultTotalCount; i += 1) {
      if (paymentConsultTotal[i].orgcd1 === contants.ORGCD1_PERSON && paymentConsultTotal[i].orgcd2 === contants.ORGCD2_PERSON) {
        perCount += 1;
      }
    }

    let delCount = 0;
    for (let i = 0; i < paymentConsultInfo.length; i += 1) {
      // 取消し伝票カウントする。
      if (paymentConsultInfo[i].delflg === 1) {
        delCount += 1;
      }
      // 未入金の請求書をカウントする。（ohterIncomeInfoのパラメータ）
      if (paymentConsultInfo[i].paymentdate === null && paymentConsultInfo[i].delflg === 0) {
        billCount += 1;
        reqDmdDate = paymentConsultInfo[i].dmddate;
        reqBillSeq = paymentConsultInfo[i].billseq;
        reqBranchNo = paymentConsultInfo[i].branchno;
      }
    }
    let perCountSpan;
    // 個人負担なし？
    if (perCount === 0) {
      perCountSpan = <span>個人負担はありません。</span>;
    // 取消し伝票しかない？
    } else if (paymentConsultInfo.length === delCount) {
      perCountSpan = <Color>請求書がありません。</Color>;
    }

    const readyCloseString = [];
    // 締め情報の存在チェック
    for (let i = 0; i < perCloseMngInfo.length; i += 1) {
      if (perCloseMngInfo[i].closedate !== '') {
        readyCloseString.push('既に締め処理が実行されています。金額の修正はできません。');
        break;
      }
    }
    return (
      <PageLayout title="個人受診金額情報">
        <MessageBanner messages={message} />
        {paymentInfo.rsvno &&
          <div>
            <Button onClick={() => { onOpenPerBillGuide(this.rsvno); }} value="請求書作成" />
            {billCount !== 0 &&
              <Button onClick={() => { onOpenPerBillAllIncomeGuide(this.rsvno); }} value="まとめて入金" />
            }
            <PerBillAllIncomeGuide />
            <Button onClick={() => { onOpenPerbillOptionGuide(this.rsvno); }} value="受診セット変更" />
            <PerBillOptionGuideForm />
            <Button onClick={() => { onOpenOtherIncomeInfoGuide(this.rsvno, billCount, reqDmdDate, reqBillSeq, reqBranchNo); }} value="セット外請求" />
            <OtherIncomeInfoGuideForm />
            <Button onClick={() => { this.handleOmitTaxAct(); }} value="消費税免除" />
            <CreatePerBillGuide />
            <PerPaymentListHeader data={paymentInfo} />
            <FieldValue>
              <Field component={CheckBox} name="delDsp" checkedValue={1} label="取消伝票も表示する" />
              <Button onClick={() => { this.handleDisplay(); }} value="表　示" />
            </FieldValue>
            <SectionBar title="お連れ様情報" />
            {paymentList.length > 0 &&
              <PerPaymentListBody data={paymentList} rsvno={this.rsvno} />
            }
            <SectionBar title="個人負担請求書情報" />
            {perCountSpan}
            {((delCount > 0 && delDsp === 1) || paymentConsultInfo.length > delCount) &&
              <PerPaymentConsultInfo data={paymentConsultInfo} delDsp={delDsp} rsvno={this.rsvno} onOpenPerBillIncomeGuide={onOpenPerBillIncomeGuide} />
            }
            <SectionBar title="個人負担金額詳細情報" />
            {readyCloseString}
            <PerPaymentConsultTotal data={paymentConsultTotal} totalData={consultmTotal} rsvno={this.rsvno} onOpenEditPerBillGuide={onOpenEditPerBillGuide} />
            <EditPerBillGuide1 />
            <EditPerBillGuide2 />
            <PerBillIncomeGuide />
            {perCloseMngInfo.length > 0 &&
              <PerCloseMngInfoList data={perCloseMngInfo} />
            }
          </div>
        }
      </PageLayout>
    );
  }
}

const PerPaymentListForm = reduxForm({
  form: formName,
  enableReinitialize: true,
})(PerPaymentList);

PerPaymentList.defaultProps = {
  formValues: undefined,
};

PerPaymentList.propTypes = {
  delDsp: PropTypes.number.isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  onDelDsp: PropTypes.func.isRequired,
  onOpenPerBillGuide: PropTypes.func.isRequired,
  onOpenEditPerBillGuide: PropTypes.func.isRequired,
  onLoad: PropTypes.func.isRequired,
  match: PropTypes.shape().isRequired,
  paymentInfo: PropTypes.shape().isRequired,
  perCloseMngInfo: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  paymentList: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  paymentConsultInfo: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  paymentConsultTotal: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  consultmTotal: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  onOpenPerBillAllIncomeGuide: PropTypes.func.isRequired,
  onOpenPerBillIncomeGuide: PropTypes.func.isRequired,
  onOpenOtherIncomeInfoGuide: PropTypes.func.isRequired,
  onOpenPerbillOptionGuide: PropTypes.func.isRequired,
  onCheckboxChg: PropTypes.func.isRequired,
  formValues: PropTypes.shape(),
};

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    message: state.app.bill.demand.payment.message,
    paymentInfo: state.app.bill.demand.payment.data.paymentInfo,
    paymentList: state.app.bill.demand.payment.data.paymentList,
    paymentConsultInfo: state.app.bill.demand.payment.data.paymentConsultInfo,
    paymentConsultTotal: state.app.bill.demand.payment.data.paymentConsultTotal,
    consultmTotal: state.app.bill.demand.payment.data.consultmTotal,
    perCloseMngInfo: state.app.bill.demand.payment.data.perCloseMngInfo,
    initialValues: {
      delDsp: state.app.bill.demand.payment.delDsp,
    },
  };
};

const mapDispatchToProps = (dispatch) => ({
  onLoad: (params) => {
    // 画面を初期化
    dispatch(getPaymentRequest({ params }));
  },

  onDelDsp: (formValues, params) => {
    dispatch(registerDelDspRequest({ formValues, params }));
  },

  onOpenPerBillGuide: (params) => {
    // 開くアクションを呼び出す
    dispatch(openCreatePerBillGuideRequest({ params }));
  },

  onOpenEditPerBillGuide: (rsvno, price, editprice, taxprice, edittax, line, flg) => {
    const params = { rsvno, price, editprice, taxprice, edittax, line, flg };
    // 開くアクションを呼び出す
    dispatch(openEditPerBillGuideRequest(params));
  },

  // まとめて入金ウィンドウ表示
  onOpenPerBillAllIncomeGuide: (rsvno) => {
    // 開くアクションを呼び出す
    dispatch(openPerbillallincomeGuide({ rsvno }));
  },

  // 入金情報ウィンドウ表示
  onOpenPerBillIncomeGuide: (rsvno, dmddate, billseq, branchno) => {
    // 開くアクションを呼び出す
    dispatch(openPerBillIncomeGuide({ rsvno, dmddate, billseq, branchno }));
  },

  // 受診セット変更ウィンドウ表示
  onOpenPerbillOptionGuide: (rsvno) => {
    // 開くアクションを呼び出す
    dispatch(openPerbillOptionGuideRequest({ rsvno }));
  },

  // セット外請求追加ウィンドウ表示
  onOpenOtherIncomeInfoGuide: (rsvno, billcount, dmddate, billseq, branchno) => {
    // 開くアクションを呼び出す
    dispatch(openOtherIncomeInfoGuideRequest({ rsvno, billcount, dmddate, billseq, branchno }));
  },

  onCheckboxChg: (value, params) => {
    dispatch(chgCheckvalue({ value }));
    dispatch(getPaymentRequest({ params }));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(PerPaymentListForm);
