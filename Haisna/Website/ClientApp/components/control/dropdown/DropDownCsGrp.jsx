import React from 'react';
import PropTypes from 'prop-types';
import axios from 'axios';

import DropDown from './DropDown';

// DropDownコンポーネントを継承した高階関数の定義
const enhance = (WrappedComponent) => class DropDownCsGrp extends React.Component {
  // コンストラクタ
  constructor() {
    super();
    this.state = { items: [{ value: 0, name: 'すべてのコース' }, { value: 1, name: '同一コースのみ' }] };
  }

  componentWillReceiveProps(nextProps) {
    console.log(nextProps.input.value);
  }
  // コンポーネントの初期処理
  componentDidMount() {
    const { rsvNo } = this.props;
    // propsで指定された汎用コードをキーに汎用レコードを得る
    const url = `/api/v1/consultations/${rsvNo}/coursegroups`;
    axios.get(
      url, {
        params: rsvNo
      }).then((res) => {
        // 汎用レコードをDropDownコンポーネントのitemsプロパティ形式に変換
        var items = res.data.map((rec) => ({
          value: rec.csgrpcd,
          name: rec.csgrpname,
        }));

        items = [...items, { value: 0, name: 'すべてのコース' }, { value: 1, name: '同一コースのみ' }];
        // stateに格納することでrenderメソッドが呼び出される
        this.setState({ items });
      });
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
  rsvNo: PropTypes.string.isRequired,
}
// defaultPropsの定義
enhance.defaultProps = {
  rsvNo: null,
}

// DropDownコンポーネント引数に高階関数を呼び出して得られた結果(=継承後のコンポーネント)をエクスポートする
export default enhance(DropDown);
