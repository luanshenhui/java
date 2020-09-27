import React from 'react';
import PropTypes from 'prop-types';

// ドロップダウン
const DropDown = (props) => {
  // redux-form対応
  // redux-formを使用した場合はprops.inputが作成され、配下にvalueやonChange等が作成される。
  // stateを変更するためにはそれらを使用する必要があるので、ここでprops.inputを参照する。
  // https://redux-form.com/7.2.3/docs/api/field.md/
  const params = props.input || props;

  const { items, addblank, blankname, isdisabled } = props;
  const { onChange, value } = params;

  return (
    <select onChange={onChange} value={value} disabled={isdisabled}>
      {addblank && <option key="" value="">{blankname}</option>}
      {items.map((item) => (
        <option key={item.value} value={item.value}>{item.name}</option>
      ))}
    </select>
  );
};

// propTypesの定義
DropDown.propTypes = {
  input: PropTypes.shape(),
  items: PropTypes.arrayOf(PropTypes.shape()),
  addblank: PropTypes.bool,
  blankname: PropTypes.string,
  isdisabled: PropTypes.string,
};

// defaultPropsの定義
DropDown.defaultProps = {
  input: undefined,
  items: [],
  addblank: false,
  blankname: '',
  isdisabled: '',
};

export default DropDown;
