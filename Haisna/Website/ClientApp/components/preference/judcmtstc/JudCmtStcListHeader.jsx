/**
 * @file 判定コメント一覧（ヘッダー）
 */
import React from 'react';
import PropTypes from 'prop-types';

import Button from '../../../components/control/Button';

import DropDownJudClass from '../../control/dropdown/DropDownJudClass';
// import JudClassDropDown from '../../JudClassDropDown';

export default class JudCmtStcListHeader extends React.Component {

  constructor(props) {
    super(props);

    // イベントハンドルの定義
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleNewRegistration = this.handleNewRegistration.bind(this);
  }

  // 検索実行
  handleSubmit(event) {
    event.preventDefault();
    this.props.onSubmit();
  }

  // 新規登録ボタンクリック
  handleNewRegistration() {
    this.props.history.push('judcmtstc/edit');
  }

  render() {
    return (
      <form onSubmit={this.handleSubmit}>
        <div>
          <p>検索条件</p>
          <div>
            判定分類：
            <DropDownJudClass name="judclasscd" value={this.props.judclasscd} onChange={this.props.onChange} className="hogeclass" />
          </div>
        </div>
        <div style={{ marginTop: 10 }}>
          <Button type="submit" value="検索" />
          <Button onClick={this.handleNewRegistration}value="新規登録" />
        </div>
      </form>
    );
  }
}

// propTypesの定義
JudCmtStcListHeader.propTypes = {
  judclasscd: PropTypes.string.isRequired,
  onChange: PropTypes.func,
  onSubmit: PropTypes.func.isRequired,
  history: PropTypes.shape({
    push: PropTypes.func,
  }).isRequired,
};

// defaultPropsの定義
JudCmtStcListHeader.defaultProps = {
  keyword: undefined,
  onChange: undefined,
};
