import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Field, reduxForm, getFormValues, blur } from 'redux-form';
import styled from 'styled-components';

import moment from 'moment';

import GuideBase from '../../components/common/GuideBase';
import MessageBanner from '../../components/MessageBanner';
import DatePicker from '../../components/control/datepicker/DatePicker';
import BulletedLabel from '../../components/control/BulletedLabel';
import Label from '../../components/control/Label';
import Button from '../../components/control/Button';
import CheckBox from '../../components/control/CheckBox';
import TextBox from '../../components/control/TextBox';
import DropDown from '../../components/control/dropdown/DropDown';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';

import MoneyFormat from './MoneyFormat';

import { closePerBillIncomeGuide, registerPerBillIncomeRequest, deletePerPaymentRequest, deletePerPaymentMessage } from '../../modules/bill/perBillModule';

import * as contants from '../../constants/common';

const Wrapper = styled.div`
  height: 780px;
  width: 820px;
  margin-top: 10px;
  padding: 0 20px;
  overflow-y: auto;
  overflow-x: hidden;
`;

const Color = styled.span`
  font-weight: bold;
  color: #ff6600;
`;

const PriceTotal = styled.span`
  font-weight: bold;
  font-size:200%;
`;

const ChangePrice = styled.span`
  font-weight: bold;
  font-size:220%;
  color: #ff8c00;
`;

// レジ番号・名称の配列作成
const registerItems = [{ value: 1, name: '1' }, { value: 2, name: '2' }, { value: 3, name: '3' }];

const formName = 'perBillIncomeGuide';

class PerBillIncomeGuide extends React.Component {
  constructor(props) {
    super(props);
    this.handleCheck = this.handleCheck.bind(this);
    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleDeleteClick = this.handleDeleteClick.bind(this);
    this.handleCancelClick = this.handleCancelClick.bind(this);
  }

  // チェックボックスをクリック
  handleCheck({ inputName, ischecked }) {
    const { setValue } = this.props;

    if (ischecked == null) {
      setValue(inputName, '');
    }

    if (ischecked == null && inputName === 'card') {
      setValue('creditslipno', '');
    }

    this.handleChange();
  }

  handleChange(values) {
    const { setValue } = this.props;

    let { credit, happyTicket, card, jdebit, cheque, transfer, priceTotal } = values;
    const { dayid, comedate } = values;

    credit = credit == null ? 0 : Number(credit);
    happyTicket = happyTicket == null ? 0 : Number(happyTicket);
    card = card == null ? 0 : Number(card);
    jdebit = jdebit == null ? 0 : Number(jdebit);
    cheque = cheque == null ? 0 : Number(cheque);
    transfer = transfer == null ? 0 : Number(transfer);
    priceTotal = priceTotal == null ? 0 : Number(priceTotal);

    const changePrice = (credit + happyTicket + card + jdebit + cheque + transfer) - priceTotal;

    let changepriceLabel = '';

    // 未受付の場合
    if (changePrice < 0 && dayid === '') {
      changepriceLabel = 'まだ受け付けていません';
    } else {
      changepriceLabel = '請求金額に達していません';

      // 未来院の場合
      if (comedate === '') {
        changepriceLabel = 'まだ来院していません';
      }
    }

    if (changePrice >= 0) {
      const changePriceFormat = changePrice.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,');
      changepriceLabel = `おつりは   \\${changePriceFormat}   です`;
    }

    setValue('changepriceLabel', changepriceLabel);
  }

  // 登録
  handleSubmit(values) {
    const { onSubmit } = this.props;

    const data = values;

    if (values.calcDate === values.closeDate) {
      // (とりあえずはconfirm文を使用しているが本来はダイアログのコンポーネントによる出力でなければならない)
      // eslint-disable-next-line no-alert,no-restricted-globals
      if (!confirm('日次締め処理が完了している日にちに対しての処理を実行しようとしています。よろしいですか？')) {
        return;
      }
    }

    if (data.card === '' || data.card === '0') {
      data.cardkind = '';
      data.creditslipno = '';
    }

    if (data.jdebit === '' || data.jdebit === '0') {
      data.bankcode = '';
    }

    onSubmit(values);
  }

  // 削除
  handleDeleteClick() {
    const { onDelete, onDelMessage, formValues } = this.props;

    const { delflg, keyDate, keySeq } = formValues;

    // 削除できない場合
    if (delflg === 1) {
      onDelMessage();
      return;
    }

    // (とりあえずはconfirm文を使用しているが本来はダイアログのコンポーネントによる出力でなければならない)
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm('この入金情報を削除します。よろしいですか？')) {
      return;
    }

    onDelete({ paymentSeq: keySeq, paymentDate: keyDate });
  }

  // キャンセル
  handleCancelClick() {
    const { onClose } = this.props;

    onClose();
  }

  render() {
    const { handleSubmit, message, formValues, cardKindItems, bankItems, billNo } = this.props;

    return (
      <GuideBase {...this.props} title="入金情報" usePagination >
        <MessageBanner messages={message} />
        <Wrapper>
          <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
            <Button value="キャンセル" onClick={this.handleCancelClick} />
            {formValues && !(formValues.wrtOkFlg === '' || formValues.printDate !== null) && <Button type="submit" value="保　存" />}
            {formValues && !(formValues.keyDate == null || formValues.keySeq == null || formValues.delflg === 1 || formValues.printDate !== null)
              && <Button onClick={this.handleDeleteClick} value="削　除" />}
            {formValues && formValues.dispMode === '1' && <Button value="戻る" />}

            <FieldGroup itemWidth={90} >
              <FieldSet>
                <FieldItem>受診日</FieldItem>
                <Label><Color>{formValues && formValues.csldate}</Color></Label>
                <FieldItem>予約番号</FieldItem>
                <Label><Color>{formValues && formValues.rsvno}</Color></Label>
              </FieldSet>
              <FieldSet>
                <FieldItem>受診コース</FieldItem>
                <Label><Color>{formValues && formValues.csname}</Color></Label>
              </FieldSet>
            </FieldGroup>

            <div style={{ marginTop: '10px' }}>
              <p>
                <span>{formValues && formValues.perid}</span>
                <span style={{ marginLeft: '25px' }}>
                  <strong>{formValues && `${formValues.lastname} ${formValues.firstname}`}</strong> {formValues && `(${formValues.lastkname}  ${formValues.firstkname})`}
                </span>
              </p>
              <p style={{ marginLeft: '95px' }}>
                <span>{formValues && formValues.birth}</span>
                <span style={{ marginLeft: '15px' }}>{formValues && `${parseInt(formValues.age, 10)}歳`}</span>
                <span style={{ marginLeft: '15px' }}>{formValues && contants.genderName[formValues.gender - 1]}</span>
              </p>
            </div>

            <div style={{ marginTop: '20px' }}>
              <BulletedLabel>請求金額を確認してください。</BulletedLabel>
              <FieldGroup itemWidth={190} >
                <FieldSet>
                  <FieldItem>対象請求書番号</FieldItem>
                  <Label>{billNo}</Label>
                </FieldSet>
                <FieldSet>
                  <FieldItem>レジ番号</FieldItem>
                  <Field name="registerno" component={DropDown} items={registerItems} />
                </FieldSet>
                <FieldSet>
                  <FieldItem>入金日</FieldItem>
                  <Field name="paymentDate" component={DatePicker} defaultDate={moment().format('YYYY/MM/DD')} id="paymentDate" />
                </FieldSet>
                <FieldSet>
                  <FieldItem>計上日</FieldItem>
                  <Field name="calcDate" component={DatePicker} id="calcDate" onChange={this.handleDateChange} />
                </FieldSet>
                <div style={{ paddingTop: '10px', paddingBottom: '20px' }}>
                  <FieldSet>
                    <FieldItem>請求金額</FieldItem>
                    <Label><PriceTotal><MoneyFormat money={formValues && formValues.priceTotal} /></PriceTotal></Label>
                  </FieldSet>
                </div>
                <FieldSet>
                  <FieldItem>
                    <Field component={CheckBox} name="checkCredit" checkedValue={1} onChange={(event, ischecked) => this.handleCheck({ inputName: 'credit', event, ischecked })} label="現金" />
                  </FieldItem>
                  預かり<Field name="credit" id="credit" component={TextBox} maxLength={8} onBlur={handleSubmit((values) => this.handleChange(values))} style={{ width: 120 }} />
                </FieldSet>
                <FieldSet>
                  <FieldItem>
                    <Field component={CheckBox} name="checkHappy" checkedValue={2} onChange={(event, ischecked) => this.handleCheck({ inputName: 'happyTicket', event, ischecked })} label="ハッピー買物券" />
                  </FieldItem>
                  預かり<Field name="happyTicket" id="happyTicket" component={TextBox} maxLength={8} onBlur={handleSubmit((values) => this.handleChange(values))} style={{ width: 120 }} />
                </FieldSet>
                <FieldSet>
                  <FieldItem>
                    <Field component={CheckBox} name="checkCard" checkedValue={3} onChange={(event, ischecked) => this.handleCheck({ inputName: 'card', event, ischecked })} label="カード" />
                  </FieldItem>
                  預かり<Field name="card" id="card" component={TextBox} maxLength={8} onBlur={handleSubmit((values) => this.handleChange(values))} style={{ width: 120 }} />
                  <Label>カード種別</Label>
                  <Field name="cardkind" component={DropDown} items={cardKindItems} />
                  <Label>伝票NO.</Label>
                  <Field name="creditslipno" id="creditslipno" component={TextBox} maxLength={5} style={{ width: 80 }} />
                </FieldSet>
                <FieldSet>
                  <FieldItem>
                    <Field component={CheckBox} name="checkJdebit" checkedValue={4} onChange={(event, ischecked) => this.handleCheck({ inputName: 'jdebit', event, ischecked })} label="Ｊデビット" />
                  </FieldItem>
                  預かり<Field name="jdebit" id="jdebit" component={TextBox} maxLength={8} onBlur={handleSubmit((values) => this.handleChange(values))} style={{ width: 120 }} />
                  &nbsp;&nbsp;<Field name="bankcode" component={DropDown} items={bankItems} />
                </FieldSet>
                <FieldSet>
                  <FieldItem>
                    <Field component={CheckBox} name="checkCheque" checkedValue={5} onChange={(event, ischecked) => this.handleCheck({ inputName: 'cheque', event, ischecked })} label="小切手・フレンズ" />
                  </FieldItem>
                  預かり<Field name="cheque" id="cheque" component={TextBox} maxLength={8} onBlur={handleSubmit((values) => this.handleChange(values))} style={{ width: 120 }} />
                </FieldSet>
                <FieldSet>
                  <FieldItem>
                    <Field component={CheckBox} name="checkTransfer" checkedValue={6} onChange={(event, ischecked) => this.handleCheck({ inputName: 'transfer', event, ischecked })} label="振込み" />
                  </FieldItem>
                  預かり<Field name="transfer" id="transfer" component={TextBox} maxLength={8} onBlur={handleSubmit((values) => this.handleChange(values))} style={{ width: 120 }} />
                </FieldSet>
              </FieldGroup>
              <div style={{ margin: '15px 0' }}>
                <ChangePrice>{formValues && formValues.changepriceLabel}</ChangePrice>
              </div>
              <FieldGroup itemWidth={170} >
                <FieldSet>
                  <FieldItem>オペレータ</FieldItem>
                  <Label>{formValues && formValues.userName}</Label>
                </FieldSet>
                <FieldSet>
                  <FieldItem>更新日時</FieldItem>
                  <Label>{formValues && moment(formValues.updDate).format('YYYY/MM/DD hh:mm:ss A')}</Label>
                </FieldSet>
                <FieldSet>
                  <FieldItem>日次締め日</FieldItem>
                  <Label>{formValues && moment(formValues.closeDate).format('YYYY/MM/DD')}</Label>
                </FieldSet>
              </FieldGroup>
            </div>
          </form>
        </Wrapper>
      </GuideBase>
    );
  }
}

const PerBillIncomeGuideForm = reduxForm({
  form: formName,
})(PerBillIncomeGuide);

// propTypesの定義
PerBillIncomeGuide.propTypes = {
  formValues: PropTypes.shape(),
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  cardKindItems: PropTypes.arrayOf(PropTypes.object).isRequired,
  bankItems: PropTypes.arrayOf(PropTypes.object).isRequired,
  billNo: PropTypes.arrayOf(PropTypes.string).isRequired,
  visible: PropTypes.bool.isRequired,
  onClose: PropTypes.func.isRequired,
  setValue: PropTypes.func.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  onDelete: PropTypes.func.isRequired,
  onDelMessage: PropTypes.func.isRequired,
};

PerBillIncomeGuide.defaultProps = {
  formValues: undefined,
};

// componentのプロパティとして紐付けるstate(状態)の定義
const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    visible: state.app.bill.perBill.perBillIncome.visible,
    message: state.app.bill.perBill.perBillIncome.message,
    billNo: state.app.bill.perBill.perBillIncome.billNo,
    cardKindItems: state.app.bill.perBill.perBillIncome.cardKindItems,
    bankItems: state.app.bill.perBill.perBillIncome.bankItems,
  };
};

// componentのプロパティとして紐付けるアクション(action)の定義
const mapDispatchToProps = (dispatch) => ({
  onClose: () => {
    dispatch(closePerBillIncomeGuide());
  },
  setValue: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur(formName, name, value));
  },
  onSubmit: (data) => {
    dispatch(registerPerBillIncomeRequest({ data }));
  },
  onDelete: (params) => {
    dispatch(deletePerPaymentRequest({ params }));
  },
  onDelMessage: () => {
    dispatch(deletePerPaymentMessage());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(PerBillIncomeGuideForm);
