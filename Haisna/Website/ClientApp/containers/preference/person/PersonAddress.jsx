import React from 'react';
import PropTypes from 'prop-types';
import { Field, formValueSelector } from 'redux-form';
import { connect } from 'react-redux';
import DropDownPref from '../../../components/control/dropdown/DropDownPref';
import { FieldGroup, FieldSet, FieldItem } from '../../../components/Field';
import GuideButton from '../../../components/GuideButton';
import TextBox from '../../../components/control/TextBox';
import SectionBar from '../../../components/SectionBar';
import Label from '../../../components/control/Label';
import Button from '../../../components/control/Button';


// 住所情報の入力フィールド
const PerAddress = ({ address, index, onOpenZipGuide, onOpenOrgGuide, onSelected, zipGuideConditions, zipGuideTargets, orgGuideTargets, peraddrs }) => (
  <div>
    {index === 0 && (
      <SectionBar title="住所（自宅）" />
    )}
    {index === 1 && (
      <SectionBar title="住所（医事）" />
    )}
    {index === 2 && (
      <SectionBar title="住所（勤務先）" />
    )}
    {index === 3 && (
      <SectionBar title="住所（その他）" />
    )}

    {(index === 0 || index === 2 || index === 3) && (
      <FieldGroup itemWidth={200}>
        {index === 2 && (
          <Button onClick={() => onOpenOrgGuide({ onSelected }, orgGuideTargets)} value="団体住所検索" />
        )}
        <FieldSet>
          <FieldItem>郵便番号</FieldItem>
          <GuideButton onClick={() => onOpenZipGuide(zipGuideTargets, zipGuideConditions)} />
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
          <FieldItem>住所１</FieldItem>
          <Field name={`${address}.address1`} component={TextBox} style={{ width: 390 }} maxLength="60" />
        </FieldSet>
        <FieldSet>
          <FieldItem>住所２</FieldItem>
          <Field name={`${address}.address2`} component={TextBox} style={{ width: 390 }} maxLength="60" />
        </FieldSet>
        <FieldSet>
          <FieldItem>電話番号１</FieldItem>
          <Field name={`${address}.tel1`} component={TextBox} style={{ width: 180 }} maxLength="15" />
        </FieldSet>
        <FieldSet>
          <FieldItem>携帯番号</FieldItem>
          <Field name={`${address}.phone`} component={TextBox} style={{ width: 180 }} maxLength="15" />
        </FieldSet>
        <FieldSet>
          <FieldItem>電話番号２</FieldItem>
          <Field name={`${address}.tel2`} component={TextBox} style={{ width: 180 }} maxLength="15" />
          <Label>内線：</Label>
          <Field name={`${address}.extension`} component={TextBox} style={{ width: 70 }} maxLength="10" />
        </FieldSet>
        <FieldSet>
          <FieldItem>FAX番号</FieldItem>
          <Field name={`${address}.fax`} component={TextBox} style={{ width: 180 }} maxLength="15" />
        </FieldSet>
        <FieldSet>
          <FieldItem>E-mailアドレス</FieldItem>
          <Field name={`${address}.email`} component={TextBox} style={{ width: 390 }} maxLength="40" />
        </FieldSet>
      </FieldGroup>
    )}
    {index === 1 && (
      <FieldGroup itemWidth={200}>
        <FieldSet>
          <FieldItem>郵便番号</FieldItem>
          <Label name={`${address}.zipcd`}>{peraddrs && peraddrs[index].zipcd}</Label>
        </FieldSet>
        <FieldSet>
          <FieldItem>都道府県</FieldItem>
          <Label name={`${address}.prefcd`}>{peraddrs && peraddrs[index].prefname}</Label>
        </FieldSet>
        <FieldSet>
          <FieldItem>市区町村</FieldItem>
          <Label name={`${address}.cityname`}>{peraddrs && peraddrs[index].cityname}</Label>
        </FieldSet>
        <FieldSet>
          <FieldItem>住所１</FieldItem>
          <Label name={`${address}.address1`}>{peraddrs && peraddrs[index].address1}</Label>
        </FieldSet>
        <FieldSet>
          <FieldItem>住所２</FieldItem>
          <Label name={`${address}.address2`}>{peraddrs && peraddrs[index].address2}</Label>
        </FieldSet>
        <FieldSet>
          <FieldItem>電話番号１</FieldItem>
          <Label name={`${address}.tel1`}>{peraddrs && peraddrs[index].tel1}</Label>
        </FieldSet>
        <FieldSet>
          <FieldItem>携帯番号</FieldItem>
          <Label name={`${address}.phone`}>{peraddrs && peraddrs[index].phone}</Label>
        </FieldSet>
        <FieldSet>
          <FieldItem>電話番号２</FieldItem>
          <Label name={`${address}.tel2`}>{peraddrs && peraddrs[index].tel2}</Label>
          <Label>内線：</Label>
          <Label name={`${address}.extension`}>{peraddrs && peraddrs[index].extension}</Label>
        </FieldSet>
        <FieldSet>
          <FieldItem>FAX番号</FieldItem>
          <Label name={`${address}.fax`}>{peraddrs && peraddrs[index].fax}</Label>
        </FieldSet>
        <FieldSet>
          <FieldItem>E-mailアドレス</FieldItem>
          <Label name={`${address}.email`}>{peraddrs && peraddrs[index].email}</Label>
        </FieldSet>
      </FieldGroup>
    )}

  </div>
);

// propTypesの定義
PerAddress.propTypes = {
  address: PropTypes.string.isRequired,
  index: PropTypes.number.isRequired,
  onOpenZipGuide: PropTypes.func.isRequired,
  zipGuideConditions: PropTypes.shape().isRequired,
  zipGuideTargets: PropTypes.shape().isRequired,
  orgGuideTargets: PropTypes.shape().isRequired,
  onOpenOrgGuide: PropTypes.func.isRequired,
  onSelected: PropTypes.func.isRequired,
  peraddrs: PropTypes.arrayOf(PropTypes.shape()).isRequired,
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
    // 団体ガイドの結果をセットするフィールド名
    orgGuideTargets: {
      zipcd: `${address}.zipcd`,
      prefcd: `${address}.prefcd`,
      cityname: `${address}.cityname`,
      address1: `${address}.address1`,
      address2: `${address}.address2`,
      tel1: `${address}.tel1`,
      tel2: `${address}.tel2`,
      extension: `${address}.extension`,
      fax: `${address}.fax`,
      email: `${address}.email`,
    },
    // 郵便番号ガイドを開く際の初期条件
    zipGuideConditions: {
      prefcd: selector(state, `${address}.prefcd`),
    },
    peraddrs: selector(state, 'peraddr'),
  };
};

export default connect(setStateToProps)(PerAddress);
