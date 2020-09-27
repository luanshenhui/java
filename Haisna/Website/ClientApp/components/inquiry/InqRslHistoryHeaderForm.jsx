/**
 * @file 結果参照 経年変化 検索フォーム
 */
import React from 'react';
import PropTypes from 'prop-types';
import { Field, reduxForm } from 'redux-form';
import moment from 'moment';

// 共通コンポーネント
import { FieldSet, FieldItem } from '../../components/Field';
import DatePicker from '../control/datepicker/DatePicker';
import DropDown from '../control/dropdown/DropDown';
import Button from '../../components/control/Button';

const form = 'inqRslHistoryHeaderForm';

// 歴ドロップダウンの選択肢
const hisCountItems = Array.from({ length: 7 }, (_, i) => ({ name: `${i + 1}`, value: `${i + 1}` }));
hisCountItems.push({ name: '全て', value: '*' });

const InqRslHistoryHeaderForm = ({ handleSubmit, onSearch, grpItems }) => (
  <form onSubmit={handleSubmit((values) => onSearch(values))} >
    <FieldSet>
      <FieldItem>検査項目グループ</FieldItem>
      <Field component={DropDown} name="grpcd" items={grpItems} addblank />
    </FieldSet>
    <FieldSet>
      <Field component={DatePicker} name="csldate" />
      <span>から過去</span>
      <Field component={DropDown} name="hiscount" items={hisCountItems} />
      <span>歴まで</span>
      <Button type="submit" value="表示" />
    </FieldSet>
  </form>
);

// propTypes定義
InqRslHistoryHeaderForm.propTypes = {
  onSearch: PropTypes.func.isRequired,
  grpItems: PropTypes.arrayOf(PropTypes.shape()),
  handleSubmit: PropTypes.func.isRequired,
};

// defaultProps定義
InqRslHistoryHeaderForm.defaultProps = {
  grpItems: [],
};

const InqRslHistoryHeader = reduxForm({
  form,
  initialValues: {
    csldate: moment().format('YYYY/MM/DD'),
    hiscount: '5',
  },
})(InqRslHistoryHeaderForm);

export default InqRslHistoryHeader;
