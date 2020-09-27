// @flow

import * as React from 'react';
import classNames from 'classnames';

// コンポーネントのインポート
import CheckBox from './CheckBox';

// cssのインポート
import styles from './LabeledCheckBox.css';

// Propsの定義
type Props = {
  className?: string,
  htmlFor?: string,
  label: string,
  onChange?: Function,
};

// コンポーネントの定義
const LabeledCheckBox = ({ className, htmlFor, label, onChange, ...others }: Props) => (
  <label htmlFor={htmlFor} className={classNames(styles.main, className)}>
    <CheckBox onChange={onChange} {...others} />
    <span className={styles.labeltext}>{label}</span>
  </label>
);

// defaultPropsの定義
LabeledCheckBox.defaultProps = {
  className: undefined,
  htmlFor: undefined,
  onChange: undefined,
};

export default LabeledCheckBox;
