// @flow

import * as React from 'react';

// Propsの定義
type Props = {
  className?: string,
  children: React.Node,
};

// コンポーネントの定義
const ListBox = ({ className, children }: Props) => (
  <div className={className}>
    {children}
  </div>
);

// defaultPropsの定義
ListBox.defaultProps = {
  className: undefined,
};

export default ListBox;
