// @flow

import * as React from 'react';
import styled from 'styled-components';

const Wrapper = styled.span`
  color: #666;
  padding: 0 5px;
`;

// Propsの定義
type Props = {
  /**
   * コンポーネントの内容
   */
  children: React.Node,
};

// Labelコンポーネントの定義
const Label = ({ children }: Props) => (
  <Wrapper>
    {children}
  </Wrapper>
);

export default Label;
