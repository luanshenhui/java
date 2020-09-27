import React from 'react';
import PropTypes from 'prop-types';
import { Field, formValueSelector } from 'redux-form';
import { connect } from 'react-redux';

import DropDownPref from '../../../components/control/dropdown/DropDownPref';
import { FieldGroup, FieldSet, FieldItem } from '../../../components/Field';
import GuideButton from '../../../components/GuideButton';
import TextBox from '../../../components/control/TextBox';
import SectionBar from '../../../components/SectionBar';

// 住所情報の入力フィールド
const OrgAddress = ({ address, index, onOpenZipGuide, zipGuideConditions, zipGuideTargets }) => (
  <div>
    <SectionBar title={`住所${index + 1}`} />
    <FieldGroup itemWidth={200}>
      <FieldSet>
        <FieldItem>宛先会社名</FieldItem>
        <Field name={`${address}.orgname`} component={TextBox} maxLength="50" />
      </FieldSet>
      <FieldSet>
        <FieldItem>郵便番号</FieldItem>
        <GuideButton onClick={() => onOpenZipGuide(zipGuideTargets, zipGuideConditions)} />
        {/* <Button onClick={() => onOpenZipGuide(zipGuideTargets, zipGuideConditions)} value="ガイド" /> */}
        <Field name={`${address}.zipcd`} component={TextBox} style={{ width: 90 }} maxLength="7" />
      </FieldSet>
      <FieldSet>
        <FieldItem>都道府県</FieldItem>
        <Field name={`${address}.prefcd`} component={DropDownPref} addblank />
      </FieldSet>
      <FieldSet>
        <FieldItem>市区町村</FieldItem>
        <Field name={`${address}.cityname`} component={TextBox} style={{ width: 390 }} maxLength="50" />
      </FieldSet>
      <FieldSet>
        <FieldItem>住所(1)</FieldItem>
        <Field name={`${address}.address1`} component={TextBox} style={{ width: 390 }} maxLength="60" />
      </FieldSet>
      <FieldSet>
        <FieldItem>住所(2)</FieldItem>
        <Field name={`${address}.address2`} component={TextBox} style={{ width: 390 }} maxLength="60" />
      </FieldSet>
      <FieldSet>
        <FieldItem>電話番号直通</FieldItem>
        <Field name={`${address}.directtel`} component={TextBox} style={{ width: 180 }} maxLength="12" />
      </FieldSet>
      <FieldSet>
        <FieldItem>電話番号代表</FieldItem>
        <Field name={`${address}.tel`} component={TextBox} style={{ width: 180 }} maxLength="12" />
      </FieldSet>
      <FieldSet>
        <FieldItem>内線</FieldItem>
        <Field name={`${address}.extension`} component={TextBox} style={{ width: 70 }} maxLength="10" />
      </FieldSet>
      <FieldSet>
        <FieldItem>FAX番号</FieldItem>
        <Field name={`${address}.fax`} component={TextBox} style={{ width: 180 }} maxLength="12" />
      </FieldSet>
      <FieldSet>
        <FieldItem>E-mail</FieldItem>
        <Field name={`${address}.email`} component={TextBox} style={{ width: 390 }} maxLength="40" />
      </FieldSet>
      <FieldSet>
        <FieldItem>URL</FieldItem>
        <Field name={`${address}.url`} component={TextBox} style={{ width: 390 }} maxLength="40" />
      </FieldSet>
      <FieldSet>
        <FieldItem>担当者カナ名</FieldItem>
        <Field name={`${address}.chargekname`} component={TextBox} style={{ width: 390 }} maxLength="30" />
      </FieldSet>
      <FieldSet>
        <FieldItem>担当者名</FieldItem>
        <Field name={`${address}.chargename`} component={TextBox} style={{ width: 390 }} maxLength="20" />
      </FieldSet>
      <FieldSet>
        <FieldItem>担当者E-Mailアドレス</FieldItem>
        <Field name={`${address}.chargeemail`} component={TextBox} style={{ width: 390 }} maxLength="40" />
      </FieldSet>
      <FieldSet>
        <FieldItem>担当部署名</FieldItem>
        <Field name={`${address}.chargepost`} component={TextBox} style={{ width: 390 }} maxLength="50" />
      </FieldSet>
    </FieldGroup>
  </div>
);

// propTypesの定義
OrgAddress.propTypes = {
  address: PropTypes.string.isRequired,
  index: PropTypes.number.isRequired,
  onOpenZipGuide: PropTypes.func.isRequired,
  zipGuideConditions: PropTypes.shape().isRequired,
  zipGuideTargets: PropTypes.shape().isRequired,
};

const setStateToProps = (state, props) => {
  const { formName, address } = props;
  const selector = formValueSelector(formName);

  return {
    // 郵便番号ガイドの結果をセットするフィールド名
    zipGuideTargets: {
      zipcd: `${address}.zipcd`,
      prefcd: `${address}.prefcd`,
      cityname: `${address}.cityname`,
      address1: `${address}.address1`,
    },
    // 郵便番号ガイドを開く際の初期条件
    zipGuideConditions: {
      prefcd: selector(state, `${address}.prefcd`),
    },
  };
};

export default connect(setStateToProps)(OrgAddress);
