import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Field, getFormValues, blur, reduxForm } from 'redux-form';

import { closeEditPerBillGuide, checkValueAndUpdatePerBillcRequest, deletePerBillcRequest } from '../../modules/bill/perBillModule';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import MessageBanner from '../../components/MessageBanner';
import GuideBase from '../../components/common/GuideBase';
import CheckBox from '../../components/control/CheckBox';
import TextBox from '../../components/control/TextBox';
import Button from '../../components/control/Button';
import Label from '../../components/control/Label';
import MoneyFormat from './MoneyFormat';

const formName = 'editPerBill1Form';

class EditPerBillGuide1 extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleCancelClick = this.handleCancelClick.bind(this);
    this.handleCheckOmitTaxFlgAct = this.handleCheckOmitTaxFlgAct.bind(this);
  }

  // 登録
  handleSubmit(values) {
    const { dmddate, billseq, branchno, billlineno, dspdivname, rsvno, priceseq, onSubmit } = this.props;
    onSubmit({ ...values, dmddate, billseq, branchno, billlineno, dspdivname, rsvno, priceseq });
  }
  // キャンセル
  handleCancelClick() {
    const { onClose } = this.props;
    onClose();
  }

  // 消費税免除チェック処理
  handleCheckOmitTaxFlgAct(ischecked) {
    const { taxprice, setValue } = this.props;
    if (ischecked !== null) {
      setValue('edittax', -1 * taxprice);
    }
  }

  render() {
    const { message, handleSubmit, formValues, orgname, optcd, optbranchno, optname } = this.props;
    return (
      <GuideBase {...this.props} title="請求明細登録・修正" usePagination={false}>
        <MessageBanner messages={message} />
        <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
          <FieldSet>
            <Button onClick={() => this.handleSubmit(formValues)} value="確定" alt="この内容で確定" />
            <Button onClick={this.handleCancelClick} value="キャンセル" style={{ marginLeft: '10px' }} alt="キャンセルする" />
          </FieldSet>
          <FieldGroup itemWidth={200}>
            <FieldSet>
              <FieldItem>負担元</FieldItem>
              <Label>{orgname}</Label>
            </FieldSet>
            <FieldSet>
              <FieldItem>対応セットコード</FieldItem>
              <Label>{optcd}-{optbranchno}</Label>
            </FieldSet>
            <FieldSet>
              <FieldItem>対応セット名</FieldItem>
              <Label>{optname}</Label>
            </FieldSet>
            <FieldSet>
              <FieldItem>請求明細名</FieldItem>
              <Field name="dsplinename" component={TextBox} id="dsplinename" style={{ width: 390 }} />
            </FieldSet>
            <FieldSet>
              <FieldItem>請求金額</FieldItem>
              <Label><MoneyFormat money={formValues && formValues.price} /></Label>
            </FieldSet>
            <FieldSet>
              <FieldItem>調整金額</FieldItem>
              <Field name="editprice" component={TextBox} id="editprice" style={{ width: 120 }} />
            </FieldSet>
            <FieldSet>
              <FieldItem>消費税</FieldItem>
              <Label><MoneyFormat money={formValues && formValues.taxprice} /></Label>
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

const EditPerBillGuide1Form = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
})(EditPerBillGuide1);

// propTypesの定義
EditPerBillGuide1.propTypes = {
  // stateと紐付けされた項目
  retPerBillList: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
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
  orgname: PropTypes.string.isRequired,
  optcd: PropTypes.string.isRequired,
  optbranchno: PropTypes.number.isRequired,
  optname: PropTypes.string.isRequired,
};

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    visible: state.app.bill.perBill.editPerBillGuide.visible,
    message: state.app.bill.perBill.editPerBillGuide.message,
    dmddate: state.app.bill.perBill.editPerBillGuide.dmddate,
    billseq: state.app.bill.perBill.editPerBillGuide.billseq,
    branchno: state.app.bill.perBill.editPerBillGuide.branchno,
    billlineno: state.app.bill.perBill.editPerBillGuide.billlineno,
    dspdivname: state.app.bill.perBill.editPerBillGuide.dspdivname,
    rsvno: state.app.bill.perBill.editPerBillGuide.rsvno,
    priceseq: state.app.bill.perBill.editPerBillGuide.priceseq,
    taxprice: state.app.bill.perBill.editPerBillGuide.taxprice,
    orgname: state.app.bill.perBill.editPerBillGuide.orgname,
    optcd: state.app.bill.perBill.editPerBillGuide.optcd,
    optbranchno: state.app.bill.perBill.editPerBillGuide.optbranchno,
    optname: state.app.bill.perBill.editPerBillGuide.optname,
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

export default connect(mapStateToProps, mapDispatchToProps)(EditPerBillGuide1Form);
