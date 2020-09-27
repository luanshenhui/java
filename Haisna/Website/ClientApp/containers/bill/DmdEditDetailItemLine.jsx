import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import Moment from 'moment';
import { connect } from 'react-redux';
import { Field, getFormValues, reduxForm, blur } from 'redux-form';

import GuideBase from '../../components/common/GuideBase';

import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import Button from '../../components/control/Button';

import Label from '../../components/control/Label';
import GuideButton from '../../components/GuideButton';
import SecondLineDivGuide from '../common/SecondLineDivGuide';
import TextBox from '../../components/control/TextBox';
import Chip from '../../components/Chip';
import MessageBanner from '../../components/MessageBanner';
import {
  registerDmdEditDetailItemLineRequest,
  deleteDmdEditDetailItemLineRequest,
  closeDmdEditDetailItemLine,
  selectSecGuide,
  deleteSelectSec,
} from '../../modules/bill/demandModule';
import { openSecondLineDivGuide } from '../../modules/preference/secondLineDivModule';

// カスタマイズfontラベル
const Font = styled.span`
    size: ${(props) => props.size};
    color: #ff0000;
`;
const formName = 'DmdEditDetailItemLine';
class DmdEditDetailItemLine extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleCancelClick = this.handleCancelClick.bind(this);
    this.handleRemoveClick = this.handleRemoveClick.bind(this);
    this.handleSelectSec = this.handleSelectSec.bind(this);
    this.handleDeleteSelectSec = this.handleDeleteSelectSec.bind(this);
  }
  handleSubmit(values) {
    const { onSubmit, datax, datay, conditions } = this.props;
    onSubmit(values, datax, conditions.selectedItem, datay.secondlinedivcd);
  }
  handleRemoveClick() {
    const { onDeleteDmdEditDetailItemLine, datax } = this.props;
    // (とりあえずはconfirm文を使用しているが本来はダイアログのコンポーネントによる出力でなければならない)
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm('この明細内訳を削除してもよろしいですか？')) {
      return;
    }
    const billNo = datax.billno;
    const itemNo = datax.itemno;
    const lineNo = datax.lineno;
    const dataDelete = { billNo, itemNo, lineNo };
    onDeleteDmdEditDetailItemLine(dataDelete);
  }
  handleCancelClick() {
    const { onClose } = this.props;
    onClose();
  }
  handleDeleteSelectSec() {
    const { onDeleteSelectSec, conditions, datay } = this.props;
    if (conditions.selectedItem !== null) {
      onDeleteSelectSec(conditions.selectedItem);
    }
    if (datay.secondlinedivcd !== undefined) {
      onDeleteSelectSec(datay);
    }
    this.forceUpdate();
  }
  handleSelectSec(selectedItem) {
    const { onSelectOneRow, setValue, conditions } = this.props;
    onSelectOneRow({ selectedItem });
    setValue('price1', conditions.selectedItem.stdprice);
    setValue('taxPrice1', conditions.selectedItem.stdtax);
    this.forceUpdate();
  }
  // 描画処理
  render() {
    const { dataCount, onOpenSecondLineDivGuide, handleSubmit, datax, datay, message, isErr, conditions } = this.props;
    return (
      <GuideBase {...this.props} title="請求明細内訳登録・修正" usePagination>
        <form onSubmit={handleSubmit((values) => this.handleSubmit(values, datax))}>
          <div>
            <FieldGroup>
              <FieldSet>
                {(datax.itemno !== undefined && isErr !== 'err') &&
                  <Button
                    value="削除"
                    onClick={() => {
                      this.handleRemoveClick();
                    }}
                  />
                }
                {isErr !== 'err' && <Button value="確 定" onClick={handleSubmit((values) => this.handleSubmit(values))} />}
                <Button value="キャンセル" onClick={this.handleCancelClick} />
              </FieldSet>
            </FieldGroup>
            {message !== undefined && (<Font><MessageBanner messages={message} /></Font>)}
            <FieldGroup itemWidth={175}>
              <FieldSet>
                <FieldItem>団体名</FieldItem>
                <Label name="orgName">{datax.orgname}</Label>
              </FieldSet>
              <FieldSet>
                <FieldItem>受診日</FieldItem>
                <Label name="cslDate">{Moment(datax.csldate).format('YYYY年MM月DD日')}</Label>
              </FieldSet>
              <FieldSet>
                <FieldItem>請求明細内訳名</FieldItem>
                <FieldSet>
                  <GuideButton
                    onClick={() => {
                      onOpenSecondLineDivGuide();
                    }}
                  />
                  {datax.itemno !== undefined && conditions.selectedItem === null && datay.secondlinedivcd !== null && (
                    <Chip
                      label={datay.secondlinedivname}
                      onDelete={() => {
                        this.handleDeleteSelectSec();
                      }}
                    />
                  )}
                  {datax.itemno === undefined && conditions.selectedItem !== null && (
                    <Chip
                      label={conditions.selectedItem.secondlinedivname}
                      onDelete={() => {
                        this.handleDeleteSelectSec();
                      }}
                    />
                  )}
                  {datax.itemno !== undefined && conditions.selectedItem !== null && (
                    <Chip
                      label={conditions.selectedItem.secondlinedivname}
                      onDelete={() => {
                        this.handleDeleteSelectSec();
                      }}
                    />
                  )}
                </FieldSet>
              </FieldSet>
              <FieldSet>
                <FieldItem>請求金額</FieldItem>
                {(dataCount[0].method === 0 || datax.LineNo == null) && (
                  <Field name="price1" component={TextBox} id="" style={{ width: 90, textAlign: 'right' }} maxLength={8} />
                )}
                {(dataCount[0].method !== 0 && datax.LineNo != null) && (
                  <Label name="price1" style={{ width: 90, textAlign: 'right' }}>{datax.price}</Label>
                )}
              </FieldSet>
              <FieldSet>
                <FieldItem>調整金額</FieldItem>
                <Field name="editPrice1" component={TextBox} id="" style={{ width: 90, textAlign: 'right' }} maxLength={8} />
              </FieldSet>
              <FieldSet>
                <FieldItem>消費税</FieldItem>
                {(dataCount[0].method === 0 || datax.LineNo == null) && (
                  <Field name="taxPrice1" component={TextBox} id="" style={{ width: 90, textAlign: 'right' }} maxLength={8} />
                )}
                {(dataCount[0].method !== 0 && datax.LineNo != null) && (
                  <Label name="taxPrice1" style={{ width: 90, textAlign: 'right' }}>{datax.taxPrice}</Label>
                )}
              </FieldSet>
              <FieldSet>
                <FieldItem>調整税額</FieldItem>
                <Field name="editTax1" component={TextBox} id="" style={{ width: 90, textAlign: 'right' }} maxLength={8} />
              </FieldSet>
            </FieldGroup>
          </div >
        </form >
        <SecondLineDivGuide
          onSelected={(selectedItem) => {
            this.handleSelectSec({ selectedItem });
          }}
        />
      </GuideBase >
    );
  }
}

// propTypesの定義
DmdEditDetailItemLine.propTypes = {
  datax: PropTypes.shape().isRequired,
  datay: PropTypes.shape().isRequired,
  conditions: PropTypes.shape().isRequired,
  handleSubmit: PropTypes.func.isRequired,
  onSelectOneRow: PropTypes.func.isRequired,
  onDeleteSelectSec: PropTypes.func.isRequired,
  dataCount: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  visible: PropTypes.bool.isRequired,
  onClose: PropTypes.func.isRequired,
  message: PropTypes.arrayOf(PropTypes.string),
  onOpenSecondLineDivGuide: PropTypes.func.isRequired,
  onDeleteDmdEditDetailItemLine: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  setValue: PropTypes.func.isRequired,
  isErr: PropTypes.string,
};
// defaultPropsの定義
DmdEditDetailItemLine.defaultProps = {
  message: undefined,
  isErr: '',
};
const DmdEditDetailItemLineForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: 'DmdEditDetailItemLine',
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(DmdEditDetailItemLine);

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    initialValues: {
      cslDate: state.app.bill.demand.dmdEditDetailItemLine.dataCount.csldate,
      orgName: state.app.bill.demand.dmdEditDetailItemLine.dataCount.orgname,
      price1: state.app.bill.demand.dmdEditDetailItemLine.datax.price === undefined
        ? state.app.bill.demand.dmdEditDetailItemLine.conditions.price : state.app.bill.demand.dmdEditDetailItemLine.datax.price,
      editPrice1: state.app.bill.demand.dmdEditDetailItemLine.datax.editprice === undefined
        ? state.app.bill.demand.dmdEditDetailItemLine.conditions.editprice : state.app.bill.demand.dmdEditDetailItemLine.datax.editprice,
      taxPrice1: state.app.bill.demand.dmdEditDetailItemLine.datax.taxprice === undefined
        ? state.app.bill.demand.dmdEditDetailItemLine.conditions.taxprice : state.app.bill.demand.dmdEditDetailItemLine.datax.taxprice,
      editTax1: state.app.bill.demand.dmdEditDetailItemLine.datax.edittax === undefined
        ? state.app.bill.demand.dmdEditDetailItemLine.conditions.edittax : state.app.bill.demand.dmdEditDetailItemLine.datax.edittax,
    },
    formValues,
    conditions: state.app.bill.demand.dmdEditDetailItemLine.conditions,
    dataCount: state.app.bill.demand.dmdEditDetailItemLine.dataCount,
    datax: state.app.bill.demand.dmdEditDetailItemLine.datax,
    datay: state.app.bill.demand.dmdEditDetailItemLine.datay,
    message: state.app.bill.demand.dmdEditDetailItemLine.message,
    visible: state.app.bill.demand.dmdEditDetailItemLine.visible,
    isErr: state.app.bill.demand.dmdEditDetailItemLine.isErr,
  };
};
const mapDispatchToProps = (dispatch) => ({
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeDmdEditDetailItemLine());
  },
  onOpenSecondLineDivGuide: () => {
    // 開くアクションを呼び出す
    dispatch(openSecondLineDivGuide());
  },
  onSubmit: (formValues, datax, selectedItem, secondlinedivCd) => {
    // 確定ボタン押下時、保存処理実行
    const billNo = datax.billno;
    const billno = billNo;
    const lineNo = datax.lineno;
    const lineno = lineNo;
    const itemNo = datax.itemno;
    const itemno = itemNo;
    let price;
    let editprice;
    let taxprice;
    let edittax;
    if (datax.method !== 0 && datax.LineNo != null) {
      if (datax.itemNo !== undefined) {
        // 修正
        if (selectedItem !== undefined) {
          const Price = datax.price;
          price = Price;
        } else {
          price = selectedItem.stdprice;
        }
      } else {
        price = selectedItem.stdprice;
      }
    } else if (formValues.price1 !== '') {
      price = formValues.price1;
    } else {
      price = 0;
    }
    if (formValues.editPrice1 !== '') {
      editprice = formValues.editPrice1;
    } else {
      editprice = 0;
    }
    if (datax.method !== 0 && datax.LineNo != null) {
      if (datax.itemNo !== undefined) {
        // 修正
        if (selectedItem !== undefined) {
          const taxPrice = datax.taxprice;
          taxprice = taxPrice;
        } else {
          price = selectedItem.stdtax;
        }
      } else {
        price = selectedItem.stdtax;
      }
    } else if (formValues.taxPrice1 !== '') {
      taxprice = formValues.taxPrice1;
    } else {
      taxprice = 0;
    }
    if (formValues.editTax1 !== '') {
      edittax = formValues.editTax1;
    } else {
      edittax = 0;
    }
    const secondlinedivcd = selectedItem == null ? secondlinedivCd : selectedItem.secondlinedivcd;
    const data = { billno, lineno, itemno, price, editprice, taxprice, edittax, secondlinedivcd };
    dispatch(registerDmdEditDetailItemLineRequest({ data }));
  },
  onDeleteDmdEditDetailItemLine: (params) => {
    // 削除ボタン押下時、削除処理実行
    dispatch(deleteDmdEditDetailItemLineRequest(params));
  },
  setValue: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur(formName, name, value));
  },
  onSelectOneRow: (params) => {
    dispatch(selectSecGuide(params));
  },
  onDeleteSelectSec: (params) => {
    dispatch(deleteSelectSec(params));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(DmdEditDetailItemLineForm);
