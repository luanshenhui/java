/**
 * @file 年コンポーネント
 */
import React from 'react';
import PropTypes from 'prop-types';
import { Field } from 'redux-form';
import styled from 'styled-components';

// 共通コンポーネント
import GuideButton from '../../components/GuideButton';
import DropDownYear from '../../components/control/dropdown/DropDownYear';

const Wrapper = styled.div`
  display: flex;
`;

const Unit = styled.div`
  margin: auto 5px;
`;

// レンダリング
const YearParameter = (props) => {
  const { yearField } = props;
  return (
    <Wrapper>
      <GuideButton onClick={() => alert('工事中です')} />
      <Field component={DropDownYear} name={yearField} addblank />
      <Unit>年</Unit>
    </Wrapper>
  );
};

// propTypesを定義
YearParameter.propTypes = {
  // 年フィールド名
  yearField: PropTypes.string.isRequired,
  // redux-formのchangeファンクション
  // eslint-disable-next-line react/no-unused-prop-types
  change: PropTypes.func.isRequired,
};

export default YearParameter;
