import React from 'react';
import PropTypes from 'prop-types';
import axios from 'axios';

class DailyListEditCondition extends React.Component {
  constructor(props) {
    super(props);
    this.state = { csName: '' };
  }

  componentDidMount() {
    const { csCd } = this.props;
    this.getCourseInfo(csCd);
  }

  // propが更新される際に呼ばれる処理
  componentWillReceiveProps(nextProps) {
    const { csCd } = nextProps;
    this.getCourseInfo(csCd);
  }

  getCourseInfo(csCd) {
    if (csCd !== '') {
      // propsで指定された汎用コードをキーに汎用レコードを得る
      axios.get(`/api/v1/courses/${csCd}`).then((res) => {
        // stateに格納することでrenderメソッドが呼び出される
        const csName = res.data.csname;
        this.setState({ csName });
      });
    } else {
      this.setState({ csName: '' });
    }
  }

  render() {
    const { orgSName, itemName, prtFieldName, getCount, print } = this.props;
    const { csName } = this.state;

    // 印刷用表示モード以外であれば編集しない
    if (print !== 1) return null;
    return (
      <span style={{ fontSize: '9px' }}>
        コース：{csName === '' ? 'すべて' : csName}&nbsp;&nbsp;
        受診団体：{orgSName === '' ? '指定なし' : orgSName}&nbsp;&nbsp;
        受診項目：{itemName === '' ? '指定なし' : itemName}<br />
        表示項目：{prtFieldName === '' ? 'デフォルト' : prtFieldName}&nbsp;&nbsp;
        {getCount === '*' ? '全データ' : `${getCount}件ずつ`}表示
      </span>
    );
  }
}

// propTypesの定義
DailyListEditCondition.propTypes = {
  csCd: PropTypes.string.isRequired,
  orgSName: PropTypes.string.isRequired,
  itemName: PropTypes.string.isRequired,
  prtFieldName: PropTypes.string.isRequired,
  getCount: PropTypes.string.isRequired,
  print: PropTypes.number.isRequired,
};

export default DailyListEditCondition;
