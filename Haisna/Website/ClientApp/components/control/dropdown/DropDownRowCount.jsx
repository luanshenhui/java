import React from 'react';
import PropTypes from 'prop-types';

import DropDown from './DropDown';

// DropDownコンポーネントを継承した高階関数の定義
const enhance = (WrappedComponent) => class DropDownCslDiv extends React.Component {
  // コンストラクタ
  constructor() {
    super();
    this.state = { items: [] };
  }

  // コンポーネントの初期処理
  componentDidMount() {
    this.getItems(this.props);
  }

  // props変更時処理（このままではpropsが変わるたびに受診区分レコード取得処理が走るため別の方法をとる必要がある）
  componentWillReceiveProps(nextProps) {
    this.getItems(nextProps);
  }

  // 受診区分レコード取得処理
  getItems(props) {
    const { itemsRows, input } = props;

    const row = [];
    if (input.value !== undefined && input.value !== '') {
      if (input.value < 95) {
        row.push(Number(input.value));

        row.push(Number(input.value) + 5);
      } else {
        row.push(95);

        row.push(100);
      }
    } else {
      row.push(itemsRows);

      row.push(itemsRows + 5);
    }

    const items = row.map((rec, index) => ({
      value: row[index],
      name: row[index],
    }));

    // stateに格納することでrenderメソッドが呼び出される
    this.setState({ items });
  }
  // render処理
  render() {
    return (
      <WrappedComponent {...this.props} items={this.state.items} />
    );
  }
};

// propTypesの定義
enhance.propTypes = {
  orgcd1: PropTypes.string,
  orgcd2: PropTypes.string,
  cscd: PropTypes.string,
  csldate: PropTypes.string,
};

// defaultPropsの定義
enhance.defaultProps = {
  orgcd1: '',
  orgcd2: '',
  cscd: '',
  csldate: '',
};

// DropDownコンポーネント引数に高階関数を呼び出して得られた結果(=継承後のコンポーネント)をエクスポートする
export default enhance(DropDown);
