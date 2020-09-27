// @flow

import { compose, withProps } from 'recompose';
import { withStyles } from '@material-ui/core/styles';
import Checkbox from '@material-ui/core/Checkbox';

// Material-UIが持つCheckboxコンポーネントのHOCとして、
// width、heightの固定サイズ指定を解除するスタイルを指定
const styles = {
  root: {
    width: 24,
    height: 24,
  },
};

const props = {
  disableRipple: true,
};

export default compose(
  withProps(props),
  withStyles(styles),
)(Checkbox);
