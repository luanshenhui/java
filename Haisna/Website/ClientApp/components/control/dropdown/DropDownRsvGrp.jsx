import React from 'react';
import PropTypes from 'prop-types';
import axios from 'axios';
import moment from 'moment';

import DropDown from './DropDown';

// DropDownコンポーネントを継承した高階関数の定義
const enhance = (WrappedComponent) => class DropDownRsvGrp extends React.Component {
  // コンストラクタ
  constructor() {
    super();
    this.state = { items: [] };
  }

  // コンポーネントの初期処理
  componentDidMount() {
    this.getItems(this.props);
  }

  // props変更時処理（このままではpropsが変わるたびに予約群レコード取得処理が走るため別の方法をとる必要がある）
  componentWillReceiveProps(nextProps) {
    this.getItems(nextProps);
  }

  // 予約群レコード取得処理
  getItems(props) {
    const { cscd, csldate, cscdrequired } = props;

    // コースコードが必須に設定されていてコースコードが指定されていない場合は選択肢をクリアする
    if (cscdrequired && cscd === '') {
      this.setState({ items: [] });
      return;
    }

    const params = { cscd };

    // 受診日の日付形式が正しければパラメータに追加
    if (csldate && moment(csldate, 'YYYY/MM/DD', true).isValid()) {
      params.csldate = csldate;
    }

    // 予約群レコード取得
    axios
      .get('/api/v1/reservationgroups/')
      .then((res) => {
        // 受診区分レコードをDropDownコンポーネントのitemsプロパティ形式に変換
        const items = res.data.map((rec) => ({
          value: rec.rsvgrpcd,
          name: rec.rsvgrpname,
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
  cscd: PropTypes.string,
  csldate: PropTypes.string,
  cscdrequired: PropTypes.bool,
};

// defaultPropsの定義
enhance.defaultProps = {
  cscd: '',
  csldate: '',
};

// DropDownコンポーネント引数に高階関数を呼び出して得られた結果(=継承後のコンポーネント)をエクスポートする
export default enhance(DropDown);
