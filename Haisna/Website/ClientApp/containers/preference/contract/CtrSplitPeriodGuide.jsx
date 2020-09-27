import React from 'react';
import PropTypes from 'prop-types';
import { Field, reduxForm, getFormValues, initialize } from 'redux-form';
import { connect } from 'react-redux';
import styled from 'styled-components';
import BulletedLabel from '../../../components/control/BulletedLabel';
import MessageBanner from '../../../components/MessageBanner';
import DatePicker from '../../../components/control/datepicker/DatePicker';
import { FieldGroup, FieldSet, FieldItem, FieldValueList, FieldValue } from '../../../components/Field';
import Label from '../../../components/control/Label';
import Button from '../../../components/control/Button';
import GuideBase from '../../../components/common/GuideBase';
import ContractGuideHeader from './ContractGuideHeader';

import { getCtrMngRequest, registerSplitRequest, getSplitDate, closeCtrSplitGuide } from '../../../modules/preference/contractModule';


const formName = 'CtrSplitPeriodGuide';

const WrapperBulleted = styled.div`
  .bullet {   
    fontSize: 1.6em;
    color: #cc9999;
    position: relative;
    top: -0.09em ; 
  };
`;

class CtrSplitPeriodGuide extends React.Component {
  // propが更新される際に呼ばれる処理
  componentWillReceiveProps(nextProps) {
    const { visible, onLoad } = this.props;
    if (nextProps.visible !== visible && visible === false) {
      // onLoadアクションの引数として渡す
      onLoad(this.props);
    }
  }

  // コンポーネントがアンマウントされる場合の処理
  componentWillUnmount() {
    // フォーム入力内容の初期化
    this.props.reset();
  }

  // 登録
  handleSubmit(values) {
    const { onSubmit, formValues } = this.props;
    const { splitDate } = formValues;
    // onSubmitアクションの引数として渡す
    onSubmit(this.props, { ...values, splitDate });
  }

  render() {
    const { handleSubmit, message, onClose, data } = this.props;
    return (
      <GuideBase {...this.props} title="契約期間の分割" usePagination={false}>
        <div>
          <MessageBanner messages={message} />
          <form>
            <div>
              <Button onClick={onClose} value="キャンセル" />
              <Button onClick={handleSubmit((values) => this.handleSubmit(values))} value="保存" />
            </div>
            <ContractGuideHeader data={data} />
            <WrapperBulleted><BulletedLabel>この契約期間を分割する分割日を指定して下さい。</BulletedLabel></WrapperBulleted>
            <FieldGroup itemWidth={180}>
              <FieldSet>
                <FieldItem>（例）契約期間</FieldItem>
                <Label>2001年&emsp;4月&emsp;1日～2002年&emsp;3月 31日</Label>
              </FieldSet>
              <FieldSet>
                <FieldItem>&emsp;&emsp;&emsp;分割日</FieldItem>
                <Label>2001年&emsp;9月 30日</Label>
              </FieldSet>
              <FieldSet>
                <FieldItem>&emsp;&emsp;&emsp;分割後の契約期間</FieldItem>
                <FieldValueList>
                  <FieldValue>
                    <Label>2001年&emsp;4月&emsp;1日～2001年&emsp;9月 30日</Label>
                  </FieldValue>
                  <FieldValue>
                    <Label>2001年 10月 30日～2002年&emsp;3月 31日</Label>
                  </FieldValue>
                </FieldValueList>
              </FieldSet>
            </FieldGroup>
            <FieldGroup itemWidth={60}>
              <FieldSet>
                <FieldItem>分割日</FieldItem>
                <Field name="splitDate" component={DatePicker} />
              </FieldSet>
            </FieldGroup>
          </form>
        </div>
      </GuideBase>
    );
  }
}

const CtrSplitPeriodGuideForm = reduxForm({
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ
  enableReinitialize: true,
})(CtrSplitPeriodGuide);

CtrSplitPeriodGuide.propTypes = {
  visible: PropTypes.bool.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  onLoad: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  onClose: PropTypes.func.isRequired,
  reset: PropTypes.func.isRequired,
  data: PropTypes.shape().isRequired,
  formValues: PropTypes.shape(),
};

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    message: state.app.preference.contract.ctrSplitPeriodGuide.message,
    // 可視状態
    visible: state.app.preference.contract.ctrSplitPeriodGuide.visible,
    data: state.app.preference.contract.contractGuideHeader.data,
  };
};

CtrSplitPeriodGuide.defaultProps = {
  formValues: undefined,
};

const mapDispatchToProps = (dispatch) => ({

  onLoad: (params) => {
    dispatch(initialize(formName, {}));
    // 画面を初期化
    dispatch(getCtrMngRequest(params));
  },

  onSubmit: (params, data) => {
    // 分割日チェック
    if (data.splitDate === undefined || data.splitDate === null) {
      dispatch(getSplitDate());
      return;
    }
    dispatch(registerSplitRequest({ params, data }));
  },
  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeCtrSplitGuide());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(CtrSplitPeriodGuideForm);
