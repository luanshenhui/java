import React from 'react';
import PropTypes from 'prop-types';
import { Field, reduxForm } from 'redux-form';
import { connect } from 'react-redux';
import styled from 'styled-components';

import MessageBanner from '../../../components/MessageBanner';
import DropDown from '../../../components/control/dropdown/DropDown';
import { FieldGroup, FieldSet, FieldItem, FieldValueList, FieldValue } from '../../../components/Field';
import Label from '../../../components/control/Label';
import Radio from '../../../components/control/Radio';
import Button from '../../../components/control/Button';
import TextBox from '../../../components/control/TextBox';
import GuideBase from '../../../components/common/GuideBase';
import ContractGuideHeader from './ContractGuideHeader';
import * as Contants from '../../../constants/common';

import { getCtrMngRequest, getCtrPtRequest, registerCtrPtRequest, closeCtrStandardGuide } from '../../../modules/preference/contractModule';

// 予約方法選択肢
const cslMethodItem = [

  { value: 1, name: '本人TEL(全部)' },
  { value: 2, name: '本人TEL(FAX有り)' },
  { value: 3, name: '本人E-MAIL' },
  { value: 4, name: '担当者TEL(全部)' },
  { value: 5, name: '担当者仮枠(FAX)' },
  { value: 8, name: '担当者仮枠(郵送)' },
  { value: 6, name: '担当者リスト' },
  { value: 7, name: '担当者E-MAIL' },

];
// 起算月選択肢
const ageCalcMonthItem = [...Array(12)].map((v, i) => ({ value: i + 1, name: (i + 1).toString() }));
// 起算日選択肢
const ageCalcDayItem = [...Array(31)].map((v, i) => ({ value: i + 1, name: (i + 1).toString() }));

const formName = 'CtrStandardGuide';

const Wrapper = styled.span`
color: #999999;
`;

class CtrStandardGuide extends React.Component {
  // propが更新される際に呼ばれる処理
  componentWillReceiveProps(nextProps) {
    const { visible, onLoad } = this.props;
    // ロケーションに変更が発生した場合に検索時イベントを呼び出す
    if (nextProps.visible !== visible && visible === false) {
      // qsを利用して変更後ロケーションのquerystringをオブジェクト型に変換し、onSearchアクションの引数として渡す
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
    const { onSubmit } = this.props;
    onSubmit(this.props, values);
  }

  render() {
    const { handleSubmit, message, onClose, data } = this.props;
    // 起算年選択肢
    const ageCalcYearItem = [];
    // 起算年選択肢値の設定
    const yearRange = [];

    for (let item = Contants.YEARRANGE_MIN; item <= Contants.YEARRANGE_MAX; item += 1) {
      yearRange.push(item);
    }

    for (let Item = 0; Item <= Contants.YEARRANGE_MAX - Contants.YEARRANGE_MIN; Item += 1) {
      ageCalcYearItem.push({ value: yearRange[Item], name: yearRange[Item].toString() });
    }

    return (
      <GuideBase {...this.props} title="契約基本情報の設定" usePagination={false}>
        <div>
          <MessageBanner messages={message} />
          <form>
            <div>
              <Button onClick={onClose} value="キャンセル" />
              <Button onClick={handleSubmit((values) => this.handleSubmit(values))} value="保存" />
            </div>
            <ContractGuideHeader data={data} />
            <FieldGroup itemWidth={118}>
              <FieldSet>
                <FieldItem>コース名</FieldItem>
                <Field name="csname" component={TextBox} style={{ width: 400, imeMode: 'active' }} maxLength={30} id="csname" />
                <Label>
                  <Wrapper>※この契約で適用するコース名を設定します。</Wrapper>
                </Label>
              </FieldSet>
              <FieldSet>
                <FieldItem>英語コース名</FieldItem>

                <Field name="csename" component={TextBox} style={{ width: 400, imeMode: 'disabled' }} maxLength={30} id="csename" />
              </FieldSet>

              <FieldSet>
                <FieldItem>予約方法</FieldItem>
                <Field name="cslmethod" component={DropDown} items={cslMethodItem} addblank id="cslmethod" />
              </FieldSet>
              <FieldSet>
                <FieldItem>年齢起算日</FieldItem>
                <FieldValueList>
                  <FieldValue>
                    <Field name="agecalc" component={Radio} checkedValue={0} label="受診日で起算する" />
                  </FieldValue>
                  <FieldValue>
                    <Field name="agecalc" component={Radio} checkedValue={1} label="起算日を直接指定" />
                    <Label>起算年：</Label>
                    <Field name="agecalcyear" component={DropDown} items={ageCalcYearItem} addblank id="agecalcyear" />
                    <Label>起算月日：</Label>
                    <Field name="agecalcmonth" component={DropDown} items={ageCalcMonthItem} addblank id="agecalcmonth" />
                    <Label>月</Label>
                    <Field name="agecalcday" component={DropDown} items={ageCalcDayItem} addblank id="agecalcday" />
                    <Label>日</Label>
                  </FieldValue>
                </FieldValueList>
              </FieldSet>
            </FieldGroup>
          </form>
        </div>
      </GuideBase>
    );
  }
}

const CtrStandardGuideForm = reduxForm({
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ
  enableReinitialize: true,

})(CtrStandardGuide);

CtrStandardGuide.propTypes = {
  visible: PropTypes.bool.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  onLoad: PropTypes.func.isRequired,
  initialValues: PropTypes.shape().isRequired,
  onSubmit: PropTypes.func.isRequired,
  onClose: PropTypes.func.isRequired,
  reset: PropTypes.func.isRequired,
  data: PropTypes.shape().isRequired,
};

const mapStateToProps = (state) => ({
  initialValues: {
    csname: state.app.preference.contract.ctrStandardGuide.data.csname,
    csename: state.app.preference.contract.ctrStandardGuide.data.csename,
    cslmethod: state.app.preference.contract.ctrStandardGuide.data.cslmethod,
    agecalc: state.app.preference.contract.ctrStandardGuide.ingagecalc,
    agecalcyear: state.app.preference.contract.ctrStandardGuide.ingagecalcyear,
    agecalcmonth: state.app.preference.contract.ctrStandardGuide.ingagecalcmonth,
    agecalcday: state.app.preference.contract.ctrStandardGuide.ingagecalcday,
  },
  message: state.app.preference.contract.ctrStandardGuide.message,
  // 可視状態
  visible: state.app.preference.contract.ctrStandardGuide.visible,
  data: state.app.preference.contract.contractGuideHeader.data,
});

const mapDispatchToProps = (dispatch) => ({

  onLoad: (params) => {
    // 画面を初期化
    dispatch(getCtrMngRequest(params));
    dispatch(getCtrPtRequest(params));
  },

  onSubmit: (params, data) => {
    dispatch(registerCtrPtRequest({ params, data }));
  },

  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeCtrStandardGuide());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(CtrStandardGuideForm);
