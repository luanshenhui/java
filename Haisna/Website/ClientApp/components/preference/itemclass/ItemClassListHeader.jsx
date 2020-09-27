import React from 'react';
import PropTypes from 'prop-types';

import Button from '../../../components/control/Button';
import TextBox from '../../../components/control/TextBox';

export default class ItemClassListHeader extends React.Component {

  constructor(props) {
    super(props);

    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleNewRegistration = this.handleNewRegistration.bind(this);
  }

  handleSubmit(event) {
    event.preventDefault();
    this.props.onSubmit();
  }

  handleNewRegistration() {
    this.props.history.push('itemclass/edit');
  }

  render() {
    return (
      <form onSubmit={this.handleSubmit}>
        <TextBox style={{ width: 500 }} name="itemclasscd" value={this.props.itemclasscd} onChange={this.props.onChange} />
        {//        <HainsCourseDropDown className="hogeclass" name="cscd" value={this.props.keyword} onChange={this.props.onChange} />
          // ここに追加のしぼりこみコントロールを追記する
        }
        <div style={{ marginTop: 10 }}>
          <Button type="submit" value="検索" />
          <Button onClick={this.handleNewRegistration} value="新規登録" />
        </div>
      </form>
    );
  }
}

// プロパティの型を定義する
ItemClassListHeader.propTypes = {
  itemclasscd: PropTypes.string.isRequired,
  onChange: PropTypes.func,
  onSubmit: PropTypes.func.isRequired,
  history: PropTypes.shape({
    push: PropTypes.func,
  }).isRequired,
};

// defaultPropsの定義
ItemClassListHeader.defaultProps = {
  keyword: undefined,
  onChange: undefined,
};
