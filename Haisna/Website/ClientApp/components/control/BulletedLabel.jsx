// @flow

import * as React from 'react';
import { setDisplayName } from 'recompose';

// Labelコンポーネントのインポート
import Label from './Label';

// Propsの定義
type Props = {
  /**
   * コンポーネントの内容
   */
  children: React.Node,
};

const enhance = (WrappedComponent: React.ComponentType<Props>) => ({ children }: Props) => (
  <WrappedComponent><span className="bullet">●</span>{children}</WrappedComponent>
);

export default setDisplayName('BulletedLabel')(enhance(Label));
