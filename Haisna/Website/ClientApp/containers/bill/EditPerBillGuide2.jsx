import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Field, getFormValues, blur, reduxForm } from 'redux-form';

import { closeEditPerBillGuide, checkValueAndUpdatePerBillcRequest, deletePerBillcRequest } from '../../modules/bill/perBillModule';
import { openGdeOtherIncomeGuideRequest, closeGdeOtherIncomeGuide } from '../../modules/bill/billModule';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import MessageBanner from '../../components/MessageBanner';
import GuideBase from '../../components/common/GuideBase';
import CheckBox from '../../components/control/CheckBox';
import TextBox from '../../components/control/TextBox';
import GuideButton from '../../components/GuideButton';
import Button from '../../components/control/Button';
import Label from '../../components/control/Label';
import GdeOtherIncomeGuide from './GdeOtherIncomeGuide';

const formName = 'editPerBill2Form';

class EditPerBillGuide2 extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleCancelClick = this.handleCancelClick.bind(this);
    this.handleDeleteClick = this.handleDeleteClick.bind(this);
    this.handleCheckOmitTaxFlgAct = this.handleCheckOmitTaxFlgAct.bind(this);
    this.handleSelectedGdeOtherIncomeGuide = this.handleSelectedGdeOtherIncomeGuide.bind(this);
  }

  // セット外請求明細のセット
  handleSelectedGdeOtherIncomeGuide(item) {
    const { setValue, onCloseGdeOtherIncomeGuide } = this.props;
    setValue('divcd', item.otherlinedivcd);
    setValue('dspdivname', item.otherlinedivname);
    setValue('dsplinename', item.otherlinedivname);
    setValue('price', item.stdprice);
    setValue('taxprice', item.stdtax);
    onCloseGdeOtherIncomeGuide();
  }

  // 登録
  handleSubmit(values) {
    const { dmddate, billseq, branchno, billlineno, dspdivname, rsvno, priceseq, divcd, onSubmit } = this.props;
    onSubmit({ ...values, dmddate, billseq, branchno, billlineno, dspdivname, rsvno, priceseq, divcd });
  }
  // キャンセル
  handleCancelClick() {
    const { onClose } = this.props;
    onClose();
  }
  // 削除
  handleDeleteClick() {
    const { onDelete, rsvno, priceseq } = this.props;
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm('このセット外請求明細を削除します。よろしいですか？')) {
      return;
    }
    onDelete({ rsvno, priceseq });
  }

  // 消費税免除チェック処理
  handleCheckOmitTaxFlgAct(ischecked) {
    const { taxprice, setValue } = this.props;
    if (ischecked !== null) {
      setValue('edittax', -1 * taxprice);
    }
  }

  render() {
    const { message, handleSubmit, formValues, onOpenGdeOtherIncomeGuide, orgcd1, orgcd2, paymentdate, paymentseq } = this.props;
    return (
      <GuideBase {...this.props} title="セット外請求明細登録・修正" usePagination={false}>
        <MessageBanner messages={message} />
        <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
          <FieldSet>
            <Button onClick={() => this.handleSubmit(formValues)} value="確定" alt="この内容で確定" />
            <Button onClick={this.handleCancelClick} value="キャンセル" style={{ marginLeft: '10px' }} alt="キャンセルする" />
            {(orgcd1 === 'XXXXX' && orgcd2 === 'XXXXX' && paymentdate === null && paymentseq === null) &&
              <Button onClick={this.handleDeleteClick} value="削除" style={{ marginLeft: '10px' }} alt="セット外請求明細を削除します" />
            }
          </FieldSet>
          <FieldGroup itemWidth={200}>
            <FieldSet>
              <FieldItem>請求先</FieldItem>
              <Label>個人受診</Label>
            </FieldSet>
            <FieldSet>
              <FieldItem>セット外請求明細名</FieldItem>
              <GuideButton onClick={() => {
                onOpenGdeOtherIncomeGuide();
              }}
              />
              <GdeOtherIncomeGuide onSelected={this.handleSelectedGdeOtherIncomeGuide} />
              <Field name="divcd" component="input" type="hidden" />
              <Label>{formValues && formValues.dspdivname}</Label>
            </FieldSet>
            <FieldSet>
              <FieldItem>請求明細名</FieldItem>
              <Field name="dsplinename" component={TextBox} id="dsplinename" style={{ width: 390 }} />
            </FieldSet>
            <FieldSet>
              <FieldItem>請求金額</FieldItem>
              <Field name="price" component={TextBox} id="price" style={{ width: 120 }} maxLength={7} />
            </FieldSet>
            <FieldSet>
              <FieldItem>調整金額</FieldItem>
              <Field name="editprice" component={TextBox} id="editprice" style={{ width: 120 }} />
            </FieldSet>
            <FieldSet>
              <FieldItem>消費税</FieldItem>
              <Field name="taxprice" component={TextBox} id="taxprice" style={{ width: 120 }} />
            </FieldSet>
            <FieldSet>
              <FieldItem>調整税額</FieldItem>
              <Field name="edittax" component={TextBox} id="edittax" style={{ width: 120 }} />
            </FieldSet>
            <FieldSet>
              <Field component={CheckBox} name="omittaxflg" checkedValue={1} onChange={(event, ischecked) => this.handleCheckOmitTaxFlgAct(ischecked)} label="消費税免除" />
            </FieldSet>
          </FieldGroup>
        </form>
      </GuideBase>
    );
  }
}

const EditPerBillGuide2Form = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
})(EditPerBillGuide2);

// propTypesの定義
EditPerBillGuide2.propTypes = {
  // stateと紐付けされた項目
  retPerBillList: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  onCloseGdeOtherIncomeGuide: PropTypes.func.isRequired,
  onOpenGdeOtherIncomeGuide: PropTypes.func.isRequired,
  formValues: PropTypes.shape().isRequired,
  onSavePerBill: PropTypes.func.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  onClose: PropTypes.func.isRequired,
  onDelete: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  setValue: PropTypes.func.isRequired,
  dmddate: PropTypes.string.isRequired,
  taxprice: PropTypes.number.isRequired,
  billseq: PropTypes.number.isRequired,
  branchno: PropTypes.number.isRequired,
  billlineno: PropTypes.number.isRequired,
  dspdivname: PropTypes.string.isRequired,
  rsvno: PropTypes.string.isRequired,
  priceseq: PropTypes.number.isRequired,
  omittaxflg: PropTypes.number.isRequired,
  divcd: PropTypes.string.isRequired,
  orgcd1: PropTypes.string.isRequired,
  orgcd2: PropTypes.string.isRequired,
  paymentdate: PropTypes.string.isRequired,
  paymentseq: PropTypes.string.isRequired,
};

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    visible: state.app.bill.perBill.editPerBillGuide2.visible,
    message: state.app.bill.perBill.editPerBillGuide.message,
    dmddate: state.app.bill.perBill.editPerBillGuide.dmddate,
    billseq: state.app.bill.perBill.editPerBillGuide.billseq,
    branchno: state.app.bill.perBill.editPerBillGuide.branchno,
    billlineno: state.app.bill.perBill.editPerBillGuide.billlineno,
    dspdivname: state.app.bill.perBill.editPerBillGuide.dspdivname,
    rsvno: state.app.bill.perBill.editPerBillGuide.rsvno,
    priceseq: state.app.bill.perBill.editPerBillGuide.priceseq,
    divcd: state.app.bill.perBill.editPerBillGuide.divcd,
    taxprice: state.app.bill.perBill.editPerBillGuide.taxprice,
    orgcd1: state.app.bill.perBill.editPerBillGuide.orgcd1,
    orgcd2: state.app.bill.perBill.editPerBillGuide.orgcd2,
    paymentdate: state.app.bill.perBill.editPerBillGuide.paymentdate,
    paymentseq: state.app.bill.perBill.editPerBillGuide.paymentseq,
    initialValues: {
      omittaxflg: state.app.bill.perBill.editPerBillGuide.omittaxflg,
    },
  };
};

// componentのプロパティとして紐付けるアクション(action)の定義
const mapDispatchToProps = (dispatch) => ({
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeEditPerBillGuide());
  },

  onOpenGdeOtherIncomeGuide: () => {
    // 開くアクションを呼び出す
    dispatch(openGdeOtherIncomeGuideRequest());
  },

  onCloseGdeOtherIncomeGuide: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeGdeOtherIncomeGuide());
  },

  onSubmit: (params) => {
    dispatch(checkValueAndUpdatePerBillcRequest({ params }));
  },

  // セット外請求明細を削除
  onDelete: (params) => {
    dispatch(deletePerBillcRequest({ params }));
  },

  setValue: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur(formName, name, value));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(EditPerBillGuide2Form);
