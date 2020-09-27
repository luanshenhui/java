import React from 'react';
import PropTypes from 'prop-types';
import { Field, getFormValues, blur, reduxForm } from 'redux-form';
import { connect } from 'react-redux';
import styled from 'styled-components';

import MessageBanner from '../../components/MessageBanner';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import Label from '../../components/control/Label';
import Button from '../../components/control/Button';
import GuideBase from '../../components/common/GuideBase';
import GuideButton from '../../components/GuideButton';
import TextBox from '../../components/control/TextBox';
import GdeOtherIncomeGuide from '../../containers/bill/GdeOtherIncomeGuide';
import OtherIncomeSubGuide from '../../containers/bill/OtherIncomeSubGuide';

import {
  closeOtherIncomeInfoGuide, openGdeOtherIncomeGuideRequest, closeGdeOtherIncomeGuide,
  closeOtherIncomeSubGuide, checkValueAndInsertPerBillcRequest, reOtherIncomeInfo,
} from '../../modules/bill/billModule';

const Wrapper = styled.div`
  height: 400px;
  margin-top: 10px;
  overflow-y: auto;
`;

const formName = 'otherIncomeInfoGuide';

class OtherIncomeInfoGuide extends React.Component {
  constructor(props) {
    super(props);

    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleCancelClick = this.handleCancelClick.bind(this);
    this.handleSelectedGdeOtherIncomeGuide = this.handleSelectedGdeOtherIncomeGuide.bind(this);
    this.handleSelectedOtherIncomeSubGuide = this.handleSelectedOtherIncomeSubGuide.bind(this);
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

  // 個人負担請求書情報の編集
  handleSelectedOtherIncomeSubGuide(item) {
    const { goOtherIncomeInfo } = this.props;
    goOtherIncomeInfo(item);
  }

  // 登録
  handleSubmit(values) {
    const { mode, dmddate, billseq, branchno, rsvno, billcount, onSubmit, onSelected } = this.props;
    onSubmit({ ...values, mode, dmddate, billseq, branchno, rsvno, billcount }, onSelected);
  }
  // キャンセル
  handleCancelClick() {
    const { onClose } = this.props;
    onClose();
  }

  render() {
    const { handleSubmit, onOpenGdeOtherIncomeGuide, message, formValues } = this.props;
    return (
      <GuideBase {...this.props} title="セット外請求明細登録・修正" usePagination >
        <MessageBanner messages={message} />
        <Wrapper>
          <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
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
                <Button onClick={() => this.handleSubmit(formValues)} value="確定" alt="この内容で確定" />
                <OtherIncomeSubGuide onSelected={this.handleSelectedOtherIncomeSubGuide} />
                <Button onClick={this.handleCancelClick} value="キャンセル" style={{ marginLeft: '10px' }} alt="キャンセルする" />
              </FieldSet>
            </FieldGroup>
          </form>
        </Wrapper>
      </GuideBase>
    );
  }
}

const OtherIncomeInfoGuideForm = reduxForm({
  form: formName,
})(OtherIncomeInfoGuide);


// propTypesの定義
OtherIncomeInfoGuide.propTypes = {
  formValues: PropTypes.shape(),
  mode: PropTypes.string.isRequired,
  dmddate: PropTypes.string.isRequired,
  billseq: PropTypes.number.isRequired,
  branchno: PropTypes.number.isRequired,
  rsvno: PropTypes.string.isRequired,
  billcount: PropTypes.number.isRequired,
  visible: PropTypes.bool.isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  handleSubmit: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  onClose: PropTypes.func.isRequired,
  onSelected: PropTypes.func.isRequired,
  setValue: PropTypes.func.isRequired,
  onOpenGdeOtherIncomeGuide: PropTypes.func.isRequired,
  onCloseGdeOtherIncomeGuide: PropTypes.func.isRequired,
  onCloseOtherIncomeSubGuide: PropTypes.func.isRequired,
  goOtherIncomeInfo: PropTypes.func.isRequired,
};

OtherIncomeInfoGuide.defaultProps = {
  formValues: undefined,
};

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    mode: state.app.bill.bill.otherIncomeInfoGuide.mode,
    rsvno: state.app.bill.bill.otherIncomeInfoGuide.rsvno,
    billcount: state.app.bill.bill.otherIncomeInfoGuide.billcount,
    dmddate: state.app.bill.bill.otherIncomeInfoGuide.dmddate,
    billseq: state.app.bill.bill.otherIncomeInfoGuide.billseq,
    branchno: state.app.bill.bill.otherIncomeInfoGuide.branchno,
    visible: state.app.bill.bill.otherIncomeInfoGuide.visible,
    message: state.app.bill.bill.otherIncomeInfoGuide.message,
  };
};

const mapDispatchToProps = (dispatch) => ({
  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeOtherIncomeInfoGuide());
  },
  onSubmit: (params, onSelected) => {
    dispatch(checkValueAndInsertPerBillcRequest({ params, onSelected }));
  },
  onOpenGdeOtherIncomeGuide: () => {
    // 開くアクションを呼び出す
    dispatch(openGdeOtherIncomeGuideRequest());
  },
  onCloseGdeOtherIncomeGuide: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeGdeOtherIncomeGuide());
  },
  onCloseOtherIncomeSubGuide: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeOtherIncomeSubGuide());
  },
  goOtherIncomeInfo: (item) => {
    dispatch(reOtherIncomeInfo(item));
  },
  setValue: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur(formName, name, value));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(OtherIncomeInfoGuideForm);
