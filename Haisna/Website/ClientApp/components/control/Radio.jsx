import React from 'react';
import PropTypes from 'prop-types';
import MuiRadio from '@material-ui/core/Radio';
import styled from 'styled-components';

import Label from './Label';

const StyledRadio = styled(MuiRadio)`
  && {
    color: #9aa9b7;
    height: 27px;
    width: inherit;
  }

  svg {
    font-size: 20px;
  }
`;

const Wrapper = styled.label`
`;

const Radio = (props) => {
  const { checked, checkedValue, input, label, name, onChange, value } = props;
  return (
    <Wrapper>
      <StyledRadio
        // inputプロパティが存在する場合、即ちredux-formのFieldコンポーネント経由で呼び出された場合は
        // input.value値とcheckedValueプロパティの値が同値であればチェック状態とする
        // それ以外の場合はcheckedプロパティの値に従う
        checked={input ? (input.value === checkedValue) : checked}
        disableRipple
        onChange={(event, ischecked) => {
          // inputプロパティが存在する場合、チェック状態であればcheckedValueプロパティの値をonChangeイベントの引数値として指定する
          if (input) {
            input.onChange(ischecked ? checkedValue : null);
            return;
          }
          // inputプロパティが存在しない場合はonChangeプロパティで指定された関数を呼び出す
          if (onChange) {
            onChange(event, ischecked);
          }
        }}
        name={name}
        value={value}
      />
      {label && <Label>{label}</Label>}
    </Wrapper>
  );
};

// propTypesの定義
Radio.propTypes = {
  checked: PropTypes.oneOfType([PropTypes.bool, PropTypes.string]),
  checkedValue: PropTypes.oneOfType([PropTypes.bool, PropTypes.number, PropTypes.string]),
  input: PropTypes.shape(),
  label: PropTypes.string,
  name: PropTypes.string,
  onChange: PropTypes.func,
  value: PropTypes.string,
};

// defaultPropsの定義
Radio.defaultProps = {
  checked: undefined,
  checkedValue: true,
  input: undefined,
  label: null,
  name: undefined,
  onChange: undefined,
  value: undefined,
};

export default Radio;
