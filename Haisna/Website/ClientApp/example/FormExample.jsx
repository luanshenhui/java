import React from 'react';
import { Field, reduxForm } from 'redux-form';
import styled from 'styled-components';

import CheckBox from '../components/control/CheckBox';
import DropDown from '../components/control/dropdown/DropDown';
import TextBox from '../components/control/TextBox';

// 請求書出力選択肢
const dropDownItems = [
  { value: 1, name: 'アイテム１' },
  { value: 2, name: 'アイテム２' },
  { value: 3, name: 'アイテム３' },
];

const Caption = styled.p`
  font-weight: bold;
  margin-top: 10px;
`;

const ExampleForm = () => (
  <div>
    <form>
      <Caption>テキストボックス</Caption>
      <Field name="textboxname" component={TextBox} style={{ width: 300 }} />
      <Caption>チェックボックス</Caption>
      <Field name="checkboxitem" component={CheckBox} label="チェックボックス" />
      <Caption>ドロップダウン</Caption>
      <Field name="dropdownitem" component={DropDown} items={dropDownItems} />
      <Caption>ドロップダウン（空要素あり）</Caption>
      <Field name="dropdownitem2" component={DropDown} items={dropDownItems} addblank />
      <Caption>ドロップダウン（空要素に名称を設定）</Caption>
      <Field name="dropdownitem3" component={DropDown} items={dropDownItems} addblank blankname="（空要素です）" />
    </form>
  </div>
);

export default reduxForm({ form: 'formExampleForm' })(ExampleForm);
