import React from 'react';
import PropTypes from 'prop-types';
import axios from 'axios';
import moment from 'moment';

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
    const { orgcd1, orgcd2, cscd, csldate } = props;

    // 団体コードが入力されていない、もしくは日付が正しくなければ選択肢をクリア
    if (orgcd1 === '' || orgcd2 === '' || !moment(csldate, 'YYYY/MM/DD', true).isValid()) {
      this.setState({ items: [] });
      return;
    }

    // 受診区分レコードを得る
    axios.get(
      `/api/v1/organizations/${orgcd1}/${orgcd2}/consultdivisions`, {
        params: {
          cscd,
          strdate: csldate,
          enddate: csldate,
        },
      },
    ).then((res) => {
      // 受診区分レコードをDropDownコンポーネントのitemsプロパティ形式に変換
      const items = res.data.map((rec) => ({
        value: rec.csldivcd,
        name: rec.csldivname,
      }));

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
