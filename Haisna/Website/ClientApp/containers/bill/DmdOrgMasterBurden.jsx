import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Field, reduxForm, getFormValues, blur } from 'redux-form';
import styled from 'styled-components';

import {
  closeDmdOrgMasterBurden,
  dmdOrgMasterBurdenRequest,
  openDmdBurdenModifyGuide,
} from '../../modules/bill/demandModule';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import Button from '../../components/control/Button';
import Label from '../../components/control/Label';
import CheckBox from '../../components/control/CheckBox';
import DatePicker from '../../components/control/datepicker/DatePicker';
import TextBox from '../../components/control/TextBox';
import GuideBase from '../../components/common/GuideBase';
import OrgGuide from '../common/OrgGuide';
import MessageBanner from '../../components/MessageBanner';
import Chip from '../../components/Chip';
import OrgParameter from './OrgParameter';

const formName = 'DmdOrgMasterBurden';

const FontColor = styled.span`
    color: #${(props) => props.color};
`;


// 登録
const handleSubmit = (values, props) => {
  const { onSubmit, onOpenDmdBurdenModifyGuide } = props;
  onSubmit(values, (billNo) => onOpenDmdBurdenModifyGuide(billNo, {}));
};

const handlePrtDateClear = (props) => {
  const { setValue } = props;
  setValue('prtDate', null);
};

const DmdOrgMasterBurden = (props) => {
  const { formValues, messages, onClose } = props;
  return (
    <GuideBase {...props} title="請求書基本情報登録" usePagination>
      <OrgGuide />
      <form>
        <div className="contents frame_content">
          <div>
            <Button onClick={() => handleSubmit(formValues, props)} value="確 定" />
            <Button onClick={() => onClose()} value="キャンセル" />
          </div>
          <FontColor color="ff6600"><MessageBanner messages={messages} /></FontColor>
          <FieldGroup itemWidth={120}>
            <FieldSet>
              <FieldItem>請求先団体</FieldItem>
              <OrgParameter {...props} formName={formName} orgCd1Field="orgCd1" orgCd2Field="orgCd2" orgNameField="orgname" />
            </FieldSet>
            <FieldSet>
              <FieldItem>締め日</FieldItem>
              <Field name="closeDate" component={DatePicker} id="" />
            </FieldSet>
            <FieldSet>
              <FieldItem>請求書出力日</FieldItem>
              <Field name="prtDate" component={DatePicker} id="" />
              <span><Chip onDelete={() => handlePrtDateClear(props)} /></span>
            </FieldSet>
            <FieldSet>
              <FieldItem>税率</FieldItem>
              <Field name="taxRates" maxLength="8" component={TextBox} id="" style={{ width: 100 }} />
              <Label><font color="#999999">　※5%の場合、0.05と入力してください。</font></Label>
            </FieldSet>
            <FieldSet>
              <FieldItem>２次検査</FieldItem>
              <Field component={CheckBox} name="secondFlg" checkedValue={1} label="" />
              <Label><font color="#999999">　※２次検査請求書の場合、チェックしてください。</font></Label>
            </FieldSet>
          </FieldGroup>
          <br />
        </div>
      </form>
    </GuideBase>
  );
};


// propTypesの定義
DmdOrgMasterBurden.propTypes = {
  setValue: PropTypes.func.isRequired,
  billNo: PropTypes.string,
  onOpenDmdBurdenModifyGuide: PropTypes.func.isRequired,
  messages: PropTypes.arrayOf(PropTypes.string).isRequired,
  conditions: PropTypes.shape().isRequired,
  onSubmit: PropTypes.func.isRequired,
  formValues: PropTypes.shape(),
  onClose: PropTypes.func.isRequired,
  visible: PropTypes.bool.isRequired,
};

// defaultPropsの定義
DmdOrgMasterBurden.defaultProps = {
  formValues: undefined,
  billNo: undefined,
};

const DmdOrgMasterBurdenForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(DmdOrgMasterBurden);

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    billNo: state.app.bill.demand.dmdOrgMasterBurden.billNo,
    messages: state.app.bill.demand.dmdOrgMasterBurden.messages,
    conditions: state.app.bill.demand.dmdOrgMasterBurden.conditions,
    formValues,
    // 可視状態
    visible: state.app.bill.demand.dmdOrgMasterBurden.visible,
    initialValues: {
      closeDate: state.app.bill.demand.dmdOrgMasterBurden.conditions.closeDate,
      taxRates: state.app.bill.demand.dmdOrgMasterBurden.conditions.taxRates,
    },
  };
};

const mapDispatchToProps = (dispatch) => ({
  setValue: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur(formName, name, value));
  },
  onSubmit: (data, redirect) => {
    dispatch(dmdOrgMasterBurdenRequest({ data, redirect }));
  },
  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeDmdOrgMasterBurden());
  },
  onOpenDmdBurdenModifyGuide: (billNo, qsParams) => {
    // 開くアクションを呼び出す
    // 請求書Ｎｏがなければ以降何もしない
    if (billNo === undefined) {
      return;
    }
    const params = {};
    params.billNo = billNo;
    params.limit = 10;
    params.page = 1;
    params.lineNo = null;
    params.params = qsParams;
    dispatch(openDmdBurdenModifyGuide(params));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(DmdOrgMasterBurdenForm);
