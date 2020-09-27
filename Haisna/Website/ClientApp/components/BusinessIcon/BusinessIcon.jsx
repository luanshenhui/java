// @flow

import * as React from 'react';
import Print from '@material-ui/icons/Print';
import Build from '@material-ui/icons/Build';

// Material-UIが持つIconコンポーネントの固定font-sizeを解除するための設定
const styles = {
  fontSize: 'inherit',
};

// Propsの定義
type Props = {
  className?: string,
  type: 'report' | 'maintenance',
};

// コンポーネントの定義
const BusinessIcon = ({ className, type }: Props) => {
  let Component;
  switch (type) {
    case 'report':
      Component = Print;
      break;
    case 'maintenance':
      Component = Build;
      break;
    default:
      return null;
  }
  return (
    <span className={className}>
      <Component style={styles} />
    </span>
  );
};

// defaultPropsの定義
BusinessIcon.defaultProps = {
  className: undefined,
};

export default BusinessIcon;
