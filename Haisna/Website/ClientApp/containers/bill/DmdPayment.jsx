import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import { connect } from 'react-redux';
import { withRouter } from 'react-router-dom';
import Moment from 'moment';
import { Field, getFormValues, reduxForm } from 'redux-form';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import Button from '../../components/control/Button';
import Label from '../../components/control/Label';
import TextArea from '../../components/control/TextArea';
import DropDown from '../../components/control/dropdown/DropDown';
import DatePicker from '../../components/control/datepicker/DatePicker';
import TextBox from '../../components/control/TextBox';
import GuideBase from '../../components/common/GuideBase';
import MessageBanner from '../../components/MessageBanner';
import MoneyFormat from './MoneyFormat';
import { closeDmdPaymentGuide, registerPaymentRequest, deletePaymentRequest } from '../../modules/bill/demandModule';

const CreateRegisternoInfo = [
  { value: '', name: '' },
  { value: 1, name: '1' },
  { value: 2, name: '2' },
  { value: 3, name: '3' }];
const getPaymentDivName = [
  { value: 1, name: '現金' },
  { value: 2, name: '小切手' },
  { value: 3, name: '振込み' },
  { value: 4, name: '福利厚生' },
  { value: 5, name: 'カード' },
  { value: 6, name: 'Ｊデビット' },
  { value: 7, name: '現金書留' },
  { value: 8, name: 'フレンズ' },
  { value: 9, name: 'その他' }];
const strArrCardKind = [
  { value: '', name: '' },
  { value: 'CARD05', name: 'DC' },
  { value: 'CARD06', name: 'DINERSCLUB' },
  { value: 'CARD07', name: 'JCBGROUP' },
  { value: 'CARD08', name: 'Master(DC)' },
  { value: 'CARD09', name: 'VISA(DC)' },
  { value: 'CARD010', name: 'UCグループ' },
  { value: 'CARD011', name: 'Million(MC)' },
  { value: 'CARD012', name: 'SAISON' },
  { value: 'CARD013', name: 'ﾋﾞｻﾞ/ﾏｽﾀｰ' },
  { value: 'CARD014', name: 'UFJ' },
  { value: 'CARD015', name: 'Amex(JCB)' },
  { value: 'CARD016', name: 'Master(UC)' }];
const strArrBankCode = [
  { value: '', name: '' },
  { value: 'BANK01', name: '郵便局' },
  { value: 'BANK02', name: 'UFJ' },
  { value: 'BANK03', name: 'みずほ' },
  { value: 'BANK04', name: '三井住友' },
  { value: 'BANK05', name: '東京三菱' },
  { value: 'BANK06', name: '千葉' },
  { value: 'BANK07', name: 'あさひ' },
  { value: 'BANK08', name: '大和' },
  { value: 'BANK09', name: '？【過去データ用】' },
  { value: 'BANK10', name: '横浜' },
  { value: 'BANK11', name: 'CITYBANK' },
  { value: 'BANK12', name: '京葉銀行' },
  { value: 'BANK13', name: '船橋信金' },
  { value: 'BANK14', name: '巣鴨信金' },
  { value: 'BANK15', name: '新生銀行' },
  { value: 'BANK16', name: 'スルガ銀行' },
  { value: 'BANK17', name: '三菱東京UFJ' },
  { value: 'BANK18', name: 'りそな' },
  { value: 'BANK19', name: 'その他' },
];
const formName = 'DmdDetailItmList';
const Font = styled.span`
    color:#${(props) => props.color};
`;

class DmdDetailItmList extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      cookie: 'billregino=2; ASPSESSIONIDSQAQSDCQ=IEHBKGMBDKLOFEDAMCBOEFLN',
    };
    this.handleRemoveClick = this.handleRemoveClick.bind(this);
    this.selectRegiNo = this.selectRegiNo.bind(this);
  }
  // レジNoが選択されたときの処理
  selectRegiNo = (event) => {
    const { target } = event;
    const curDate = new Date();
    // const previsit = curDate.toGMTString();
    curDate.setTime((curDate.getTime() + (30 * 365 * 24 * 60 * 60 * 1000))); // 30年後
    const expire = curDate.toGMTString();
    this.state.cookie = `billregino=${target.value};expires=${expire}`;
  }
  // 削除確認メッセージ
  handleRemoveClick() {
    const { onDelete, data, conditions } = this.props;
    // (とりあえずはconfirm文を使用しているが本来はダイアログのコンポーネントによる出力でなければならない)
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm('指定された入金情報を削除します。よろしいですか。')) {
      return;
    }
    onDelete(data.billno, data.seq, conditions);
  }
  //
  // 登録
  handleSubmit(values) {
    const { conditions, data, onSubmit, dataDPBS, re, formValues } = this.props;
    const checkPaymentData = {};
    const lngdelflg = dataDPBS.lngDelFlg;
    const branchNo = re.lngBranchNo;
    const closeDate = dataDPBS.closedate;
    const billSeq = re.lngBillSeq;
    const Date = Moment(formValues.paymentdate).format('YYYYMMDD');
    const paymentYear = Number(Date.substr(0, 4));
    const paymentMonth = Number(Date.substr(4, 2));
    const paymentDay = Number(Date.substr(6, 2));
    const paymentPrice = formValues.strPaymentPrice;
    const paymentDiv = Number(formValues.paymentdiv);
    const payNote = formValues.paynote;
    let cardKind = formValues.cardkind;
    let registerNo = null;
    if (formValues.registerno === null || formValues.registerno === undefined || formValues.registerno === '') {
      registerNo = null;
    } else {
      registerNo = Number(formValues.registerno);
    }
    let Cash = null;

    if (Number(formValues.strPaymentDiv) === 1) {
      Cash = formValues.cash;
    } else {
      Cash = formValues.paymentprice;
    }
    const cash = Cash;
    let creditslipNo = formValues.creditslipno;
    let bankCode = formValues.bankcode;
    // 入金日入力チェック
    const reg = /^[1-9]\d{3}[/](0[1-9]|1[0-2])[/](0[1-9]|[1-2][0-9]|3[0-1])$/;
    const regExp = new RegExp(reg);
    if (!regExp.test(Moment(formValues.paymentdate).format('YYYY/MM/DD'))) {
      // (とりあえずはconfirm文を使用しているが本来はダイアログのコンポーネントによる出力でなければならない)
      // eslint-disable-next-line no-alert,no-restricted-globals
      alert('入金日の形式に誤りがあります。');
      return;
    }
    // 入金日編集
    const paymentDate = new Moment(formValues.paymentdate);
    const closedate = new Moment(closeDate);
    if (paymentDate < closedate) {
      // (とりあえずはconfirm文を使用しているが本来はダイアログのコンポーネントによる出力でなければならない)
      // eslint-disable-next-line no-alert,no-restricted-globals
      alert('入金日は締め日以降の日付を入力してください。');
      return;
    }
    // 2004.01.28 追加
    if (Number(formValues.paymentdiv) !== 5) {
      cardKind = '';
      creditslipNo = '';
      formValues.cardkind = null;
      formValues.creditslipno = null;
    }
    if (Number(formValues.paymentdiv) !== 6) {
      bankCode = '';
      formValues.bankcode = null;
    }
    onSubmit(
      {
        ...data, lngdelflg, branchNo, closeDate, billSeq, paymentYear, paymentMonth, paymentDay, paymentPrice, paymentDiv, payNote, cardKind, registerNo, cash, creditslipNo, bankCode,
      },
      {
        ...checkPaymentData, closeDate, billSeq, paymentYear, paymentMonth, paymentDay, paymentPrice, paymentDiv, payNote, branchNo, seq: data.seq,
      },
      { ...values, paymentprice: paymentPrice, cardkind: cardKind, creditslipno: creditslipNo, bankcode: bankCode },
      conditions,
    );
  }
  render() {
    const { onClose, dataDPBS, dataPay, rec, handleSubmit, formValues, re, data, message, strDispCharge } = this.props;
    let PaymentDivName = '';
    if ((re.lngBranchNo === 0 && dataDPBS.lngDelFlg === 1) || rec.flgNoInput === 1) {
      PaymentDivName = '';
      for (let i = 0; i < getPaymentDivName.length; i += 1) {
        if (getPaymentDivName[i].value === formValues.paymentdiv) {
          PaymentDivName = getPaymentDivName[i].name;
        }
      }
    }
    return (
      <GuideBase {...this.props} title="入金処理" usePagination >
        <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
          <div className="contents frame_content" width="612">
            <FieldGroup>
              <FieldSet>
                {(re.lngBranchNo === 1 || dataDPBS.lngDelFlg === 0) && (
                  <FieldSet>
                    {data.seq !== null && (
                      <div>
                        <Button onClick={this.handleRemoveClick} value="削 除" />
                        <Font width="190">{}</Font>
                      </div>
                    )}
                    {data.seq === null && (
                      <Font width="264">{}</Font>
                    )}
                    {((re.lngBranchNo === 0 && dataDPBS.lngDelFlg === 1) || rec.flgNoInput === 1) && (
                      <div>
                        <Button value="確 定" />
                      </div>
                    )}
                    {!((re.lngBranchNo === 0 && dataDPBS.lngDelFlg === 1) || rec.flgNoInput === 1) && (
                      <div>
                        <Button type="submit" value="確 定" />
                      </div>
                    )}
                  </FieldSet>
                )}
                <FieldSet>
                  <Button value="キャンセル" onClick={() => onClose()} />
                </FieldSet>
              </FieldSet>
            </FieldGroup>
            <br />
            <div>
              <Font color="ff0000"><MessageBanner messages={message} /></Font>
            </div>
            <FieldGroup>
              <FieldSet>
                <FieldItem>締め日</FieldItem>
                <Label>{Moment(dataDPBS.closedate).format('YYYY/MM/DD')}</Label>
              </FieldSet>
              <FieldSet>
                <FieldItem>請求先</FieldItem>
                <Label>{dataDPBS.orgname}</Label>
              </FieldSet>
              <FieldSet>
                <FieldItem>請求金額</FieldItem>
                <Label><b><MoneyFormat money={dataDPBS.total} /></b></Label>
              </FieldSet>
              <FieldSet>
                <FieldItem>未収金額</FieldItem>
                {dataDPBS.notpayment === 0 && (
                  <Label><Font><b><MoneyFormat money={dataDPBS.notpayment} /></b></Font></Label>
                )}
                {dataDPBS.notpayment !== 0 && (
                  <Label><Font color="ff0000" ><b><MoneyFormat money={dataDPBS.notpayment} /></b></Font></Label>
                )}
              </FieldSet>
            </FieldGroup>
            <br />
            <FieldGroup>
              {((re.lngBranchNo === 0 && dataDPBS.lngDelFlg === 1) || rec.flgNoInput === 1) && (
                <FieldGroup>
                  <FieldSet>
                    <FieldItem>レジ番号</FieldItem>
                    <Label><b>{formValues && formValues.registerno}</b></Label>
                  </FieldSet>
                  <FieldSet>
                    <FieldItem>入金日</FieldItem>
                    {(formValues && formValues.paymentdate) !== undefined && (
                      <Label><b>{Moment(formValues && formValues.paymentdate).format('YYYY/MM/DD')}</b></Label>
                    )}
                    {(formValues && formValues.paymentdate) === undefined && (
                      <Label><b>{formValues && formValues.paymentdate}</b></Label>
                    )}
                  </FieldSet>
                  <FieldSet>
                    <FieldItem>入金額</FieldItem>
                    {Number(formValues && formValues.strPaymentDiv) === 1 && (
                      <Label><b>{formValues && formValues.cash}</b><Font color="999999">おつりは <MoneyFormat money={strDispCharge} /> です。</Font></Label>
                    )}
                    {Number(formValues && formValues.strPaymentDiv) !== 1 && (
                      <Label>{formValues.strDispPayment}</Label>
                    )}
                  </FieldSet>
                  <FieldSet>
                    <FieldItem>入金種別</FieldItem>
                    {Number(formValues && formValues.strPaymentDiv) === 5 && (
                      <FieldSet>
                        <Label >{PaymentDivName}</Label>
                        <FieldItem>&nbsp;カード種別&nbsp;</FieldItem>
                        <Label >{formValues && formValues.cardname}</Label>
                        <FieldItem>&nbsp;伝票No.&nbsp;</FieldItem>
                        <Label >{formValues && formValues.creditslipno}</Label>
                      </FieldSet>
                    )}
                    {Number(formValues && formValues.strPaymentDiv) === 6 && (
                      <FieldSet>
                        <Label >{PaymentDivName}</Label>
                        <FieldItem>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            金融機関
                        </FieldItem>
                        <Label >{formValues && formValues.bankname}</Label>
                      </FieldSet>
                    )}
                    {(Number(formValues.strPaymentDiv) !== 5 && Number(formValues.strPaymentDiv) !== 6) && (
                      <Label >{PaymentDivName}</Label>
                    )}
                  </FieldSet>
                  <FieldSet>
                    <FieldItem>コメント</FieldItem>
                    <Label >{formValues && formValues.paynote}</Label>
                  </FieldSet>
                </FieldGroup>
              )}
              {(!((re.lngBranchNo === 0 && dataDPBS.lngDelFlg === 1) || rec.flgNoInput === 1)) && (
                <FieldGroup>
                  <FieldSet>
                    <FieldItem>レジ番号</FieldItem>
                    <Field name="registerno" component={DropDown} items={CreateRegisternoInfo} id="" onChange={this.selectRegiNo} />
                  </FieldSet>
                  <FieldSet>
                    <FieldItem>入金日</FieldItem>
                    <Field name="paymentdate" component={DatePicker} id="" />
                  </FieldSet>
                  <FieldSet>
                    <FieldItem>入金額</FieldItem>
                    {Number(formValues && formValues.strPaymentDiv) === 1 && (
                      <FieldSet>
                        <Field name="cash" component={TextBox} id="" maxLength="9" style={{ imeMode: 'disabled', width: 100 }} />
                        <Font color="999999">おつりは <MoneyFormat money={strDispCharge} /> です。</Font>
                      </FieldSet>
                    )}
                    {Number(formValues && formValues.strPaymentDiv) !== 1 && (
                      <FieldSet>
                        <Field name="paymentprice" component={TextBox} id="" maxLength="9" style={{ imeMode: 'disabled', width: 100 }} />
                      </FieldSet>
                    )}
                  </FieldSet>
                  <FieldSet>
                    <Label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                      <Font color="999999">※入金種別=現金以外の入金額は無視されます。（請求金額とイコールになります）</Font>
                    </Label>
                  </FieldSet>
                  <FieldSet>
                    <FieldItem>入金種別</FieldItem>
                    <Field name="paymentdiv" component={DropDown} items={getPaymentDivName} id="" />
                    <FieldItem>&nbsp;カード種別&nbsp;</FieldItem>
                    <Field name="cardkind" component={DropDown} items={strArrCardKind} id="" />
                    <FieldItem>&nbsp;伝票No.&nbsp;</FieldItem>
                    <Field name="creditslipno" component={TextBox} id="" maxLength="5" style={{ imeMode: 'disabled', width: 80 }} />
                  </FieldSet>
                  <FieldSet>
                    <FieldItem>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                          金融機関
                    </FieldItem>
                    <Field name="bankcode" component={DropDown} items={strArrBankCode} id="" />
                  </FieldSet>
                  <FieldSet>
                    <FieldItem>コメント</FieldItem>
                    <Field name="paynote" component={TextArea} id="" style={{ width: 300, height: 50 }} />
                  </FieldSet>
                </FieldGroup>
              )}
              <FieldSet>
                <FieldItem>処理担当者</FieldItem>
                <Label>{dataPay.username}</Label>
              </FieldSet>
            </FieldGroup>
          </div>
        </form>
      </GuideBase >
    );
  }
}
// propTypesの定義
DmdDetailItmList.propTypes = {
  history: PropTypes.shape().isRequired,

  onClose: PropTypes.func.isRequired,
  dataDPBS: PropTypes.shape().isRequired,
  dataDPP: PropTypes.shape().isRequired,
  onDelete: PropTypes.func.isRequired,
  dataPay: PropTypes.shape().isRequired,
  dataDetail: PropTypes.arrayOf(PropTypes.arrayOf).isRequired,
  rec: PropTypes.shape().isRequired,
  formValues: PropTypes.shape(),
  onSubmit: PropTypes.func.isRequired,
  data: PropTypes.shape().isRequired,
  re: PropTypes.shape().isRequired,
  handleSubmit: PropTypes.func.isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  conditions: PropTypes.shape().isRequired,
  strDispCharge: PropTypes.number,
};
const DmdDetailItmListForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
})(DmdDetailItmList);
DmdDetailItmList.defaultProps = {
  formValues: undefined,
  strDispCharge: null,
};
// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    // 初期値設定
    initialValues: {
    },
    formValues,
    // 可視状態
    visible: state.app.bill.demand.dmdPaymentGuide.visible,
    message: state.app.bill.demand.dmdPaymentGuide.message,
    dataDPBS: state.app.bill.demand.dmdPaymentGuide.dataDPBS,
    dataDPP: state.app.bill.demand.dmdPaymentGuide.dataDPP,
    dataPay: state.app.bill.demand.dmdPaymentGuide.dataPay,
    dataDetail: state.app.bill.demand.dmdPaymentGuide.dataDetail,
    rec: state.app.bill.demand.dmdPaymentGuide.rec,
    data: state.app.bill.demand.dmdPaymentGuide.data,
    re: state.app.bill.demand.dmdPaymentGuide.re,
    conditions: state.app.bill.demand.dmdBurdenList.conditions,
    strDispCharge: state.app.bill.demand.dmdPaymentGuide.strDispCharge,
  };
};
const mapDispatchToProps = (dispatch) => ({
  onClose: () => {
    dispatch(closeDmdPaymentGuide());
  },
  onSubmit: (params, checkPaymentData, data, conditions) => {
    const formname = 'DmdDetailItmList';
    dispatch(registerPaymentRequest({ params, checkPaymentData, data, conditions, formname }));
  },
  onDelete: (billno, seq, conditions) => dispatch(deletePaymentRequest({ billno, seq, conditions })),
});
export default withRouter(connect(mapStateToProps, mapDispatchToProps)(DmdDetailItmListForm));
