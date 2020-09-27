import React from 'react';
import PropTypes from 'prop-types';


let Money;
// マネーのフォーマット
const MoneyFormat = (props) => {
  const { money } = props;
  if (money != null && money >= 0) {
    Money = `¥${String(money).replace(/\B(?=(\d{3})+(?!\d))/g, ',')}`;
  } else if (money != null && money < 0) {
    Money = `-¥${String(money * -1).replace(/\B(?=(\d{3})+(?!\d))/g, ',')}`;
  }
  return (
    <nobr>{Money}</nobr>
  );
};

// propTypesの定義
MoneyFormat.propTypes = {
  money: PropTypes.number,
};

// defaultPropsの定義
MoneyFormat.defaultProps = {
  money: undefined,
};

export default MoneyFormat;
