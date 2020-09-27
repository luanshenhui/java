import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Field, reduxForm, getFormValues, blur } from 'redux-form';
import styled from 'styled-components';
import Moment from 'moment';

import {
  closeDmdEditBillLine,
  saveBillDetailRequest,
  deleteBillLineRequest,
} from '../../modules/bill/demandModule';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import Button from '../../components/control/Button';
import Label from '../../components/control/Label';
import DatePicker from '../../components/control/datepicker/DatePicker';
import TextBox from '../../components/control/TextBox';
import GuideBase from '../../components/common/GuideBase';
import MessageBanner from '../../components/MessageBanner';
import PersonGuide from '../common/PersonGuide';
import PersonParameter from './PersonParameter';

const FontColor = styled.span`
    color: #${(props) => props.color};
`;

const formName = 'DmdEditBillLine';
class DmdEditBillLine extends React.Component {
  constructor(props) {
    super(props);

    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleRemoveClick = this.handleRemoveClick.bind(this);
  }

  componentWillReceiveProps(nextProps) {
    const { visible, setValues } = this.props;

    if (!visible && nextProps.visible !== visible) {
      setValues('CslDate', Moment().format('YYYY/MM/DD'));
      setValues('DayId', null);
      setValues('RsvNo', null);
      setValues('DetailName', null);
      setValues('Price', 0);
      setValues('EditPrice', 0);
      setValues('TaxPrice', 0);
      setValues('EditTax', 0);
      setValues('perId', null);
    }
  }

  // 登録・修正
  handleSubmit = (values) => {
    const { onSubmit, params, strLineNo } = this.props;
    onSubmit({ ...values, ...params }, strLineNo);
  }

  // 削除
  handleRemoveClick() {
    const { onDelete, params, onClose, billDetail } = this.props;
    const orgcd = { orgCd1: billDetail[0].orgcd1, orgCd2: billDetail[0].orgcd2 };
    const rsvNo = billDetail[0].rsvno;
    const billNo = params.BillNo;
    // (とりあえずはconfirm文を使用しているが本来はダイアログのコンポーネントによる出力でなければならない)
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm('このデータを削除しますか？')) {
      return;
    }

    onDelete({ ...params, ...orgcd, rsvNo, billNo }, () => onClose());
  }

  render() {
    const { billDetail, formValues, onClose, strLineNo, message, strNoEditFlg, sumPrice } = this.props;

    return (
      <GuideBase {...this.props} title="請求明細登録・修正" usePagination>
        <PersonGuide />
        <form>
          <div className="contents frame_content">
            <div>
              {strLineNo && (
                  (strNoEditFlg === 0 && (
                    <Button onClick={this.handleRemoveClick} value="削 除" />)
                  ))}
              {strNoEditFlg === 0 && (
                <Button onClick={() => this.handleSubmit(formValues)} value="確 定" />
              )}
              <Button onClick={() => onClose()} value="キャンセル" />
            </div>
            <FontColor color="ff0000"><MessageBanner messages={message} /></FontColor>
            <FieldGroup itemWidth={120}>
              <FieldSet>
                <FieldItem>団体名</FieldItem>
                <Label name="">{billDetail[0].orgname}</Label>
              </FieldSet>
              <FieldSet>
                <FieldItem>受診日</FieldItem>
                <Field name="CslDate" component={DatePicker} id="" />
              </FieldSet>
              <FieldSet>
                <FieldItem>当日ID</FieldItem>
                {(billDetail[0].method === 0 || strLineNo == null)
                   ? <Field name="DayId" component={TextBox} maxLength="5" style={{ width: 60 }} />
                    : <Label name="DayId">{billDetail[0].dayid}</Label>
                }
              </FieldSet>
              <FieldSet>
                <FieldItem>予約番号</FieldItem>
                {(billDetail[0].method === 0 || strLineNo == null)
                   ? <Field name="RsvNo" component={TextBox} maxLength="9" style={{ width: 90 }} />
                    : <Label name="RsvNo">{billDetail[0].rsvno}</Label>
                }
              </FieldSet>
              <FieldSet>
                <FieldItem>請求明細名</FieldItem>
                <Field name="DetailName" component={TextBox} maxLength="30" style={{ width: 200 }} />
              </FieldSet>
              <FieldSet>
                <FieldItem>氏名</FieldItem>
                <PersonParameter {...this.props} formName={formName} peridField="perId" lastNameField="lastName" firstNameField="firstName" />
              </FieldSet>
              <FieldSet>
                <FieldItem>請求金額</FieldItem>
                {billDetail[0].secondflg !== 1
                && ((billDetail[0].method === 0 || strLineNo == null)
                    ? <Field name="Price" component={TextBox} maxLength="8" style={{ width: 90 }} />
                    : <Label name="Price">{billDetail[0].price}</Label>)}
                {billDetail[0].secondflg === 1 && (
                <Label name="Price">{sumPrice.lngSumPrice}</Label>
                )}
              </FieldSet>
              <FieldSet>
                <FieldItem>調整金額</FieldItem>
                {billDetail[0].secondflg !== 1
                    ? <Field name="EditPrice" component={TextBox} maxLength="8" style={{ width: 90 }} />
                    : <Label name="EditPrice">{sumPrice.lngSumEditPrice}</Label>
                }
              </FieldSet>
              <FieldSet>
                <FieldItem>消費税</FieldItem>
                {billDetail[0].secondflg !== 1
                    && ((billDetail[0].method === 0 || strLineNo == null)
                    ? <Field name="TaxPrice" component={TextBox} maxLength="8" style={{ width: 90 }} />
                    : <Label name="TaxPrice">{billDetail[0].taxprice}</Label>)}
                {billDetail[0].secondflg === 1 && (
                <Label name="TaxPrice">{sumPrice.lngSumTaxPrice}</Label>
                )}
              </FieldSet>
              <FieldSet>
                <FieldItem>調整税額</FieldItem>
                {billDetail[0].secondflg !== 1
                    ? <Field name="EditTax" component={TextBox} maxLength="8" style={{ width: 90 }} />
                    : <Label name="EditTax">{sumPrice.lngSumEditTax}</Label>
                }
              </FieldSet>
            </FieldGroup>
          </div>
        </form>
      </GuideBase>
    );
  }
}

// propTypesの定義
DmdEditBillLine.propTypes = {
  visible: PropTypes.bool.isRequired,
  setValues: PropTypes.func.isRequired,
  sumPrice: PropTypes.shape().isRequired,
  strNoEditFlg: PropTypes.number.isRequired,
  strLineNo: PropTypes.string.isRequired,
  onDelete: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  formValues: PropTypes.shape(),
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  billDetail: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  params: PropTypes.shape().isRequired,
  onClose: PropTypes.func.isRequired,
};

DmdEditBillLine.defaultProps = {
  formValues: undefined,
};

const DmdEditBillLineForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(DmdEditBillLine);

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  const { strLineNo } = state.app.bill.demand.dmdEditBillLine;
  return {
    sumPrice: state.app.bill.demand.dmdEditBillLine.sumPrice,
    strNoEditFlg: state.app.bill.demand.dmdEditBillLine.strNoEditFlg,
    strLineNo: state.app.bill.demand.dmdEditBillLine.strLineNo,
    formValues,
    message: state.app.bill.demand.dmdEditBillLine.message,
    billDetail: state.app.bill.demand.dmdEditBillLine.billDetail,
    params: state.app.bill.demand.dmdEditBillLine.params,
    visible: state.app.bill.demand.dmdEditBillLine.visible,
    initialValues: {
      perId: state.app.bill.demand.dmdEditBillLine.billDetail[0].perid,
      lastName: state.app.bill.demand.dmdEditBillLine.billDetail[0].lastname,
      firstName: state.app.bill.demand.dmdEditBillLine.billDetail[0].firstname,
      CslDate: (strLineNo == null || strLineNo === '')
        ? state.app.bill.demand.dmdEditBillLine.conditions.CslDate
        : state.app.bill.demand.dmdEditBillLine.billDetail[0].csldate,
      DayId: state.app.bill.demand.dmdEditBillLine.billDetail[0].dayid,
      RsvNo: state.app.bill.demand.dmdEditBillLine.billDetail[0].rsvno,
      DetailName: state.app.bill.demand.dmdEditBillLine.billDetail[0].detailname,
      Price: state.app.bill.demand.dmdEditBillLine.billDetail[0].price == null
        ? state.app.bill.demand.dmdEditBillLine.conditions.Price
        : state.app.bill.demand.dmdEditBillLine.billDetail[0].price,
      EditPrice: state.app.bill.demand.dmdEditBillLine.billDetail[0].editprice == null
        ? state.app.bill.demand.dmdEditBillLine.conditions.EditPrice
        : state.app.bill.demand.dmdEditBillLine.billDetail[0].editprice,
      TaxPrice: state.app.bill.demand.dmdEditBillLine.billDetail[0].taxprice == null
        ? state.app.bill.demand.dmdEditBillLine.conditions.TaxPrice
        : state.app.bill.demand.dmdEditBillLine.billDetail[0].taxprice,
      EditTax: state.app.bill.demand.dmdEditBillLine.billDetail[0].edittax == null
        ? state.app.bill.demand.dmdEditBillLine.conditions.EditTax
        : state.app.bill.demand.dmdEditBillLine.billDetail[0].edittax,
    },
  };
};

const mapDispatchToProps = (dispatch) => ({
  setValues: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur(formName, name, value));
  },
  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeDmdEditBillLine());
  },
  onSubmit: (params, strlineNo) => {
    // 登録・修正
    dispatch(saveBillDetailRequest({ params, strlineNo }));
  },
  // 削除
  onDelete: (params, redirect) => dispatch(deleteBillLineRequest({ params, redirect })),
});

export default connect(mapStateToProps, mapDispatchToProps)(DmdEditBillLineForm);
