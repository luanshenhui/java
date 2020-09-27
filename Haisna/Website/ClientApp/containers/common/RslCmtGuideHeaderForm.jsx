import React from 'react';
import PropTypes from 'prop-types';
import { reduxForm } from 'redux-form';
import { withRouter } from 'react-router-dom';
import { connect } from 'react-redux';
import qs from 'qs';

import { getRslCmtList } from '../../modules/preference/rslCmtModule';

class RslCmtGuideHeaderForm extends React.Component {

  // コンポーネントがマウントされた直後に1回だけ呼ばれる処理
  componentDidMount() {
    // フォーム入力内容の初期化
    this.props.reset();

    const { location, onSearch } = this.props;
    // qsを利用してquerystringをオブジェクト型に変換し、onSearchアクションの引数として渡す
    onSearch(qs.parse(location.search.substr(1)));
  }

  render() {
    return (
      <div>
        <p>結果コメントを選択して下さい。</p>
      </div>
    );
  }
}

// propTypesの定義
RslCmtGuideHeaderForm.propTypes = {
  reset: PropTypes.func.isRequired,
  location: PropTypes.shape().isRequired,
  onSearch: PropTypes.func.isRequired,
};

const RslCmtGuideHeader = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: 'rslCmtGuideHeader',
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(RslCmtGuideHeaderForm);

const mapStateToProps = () => ({
  initialValues: { keyword: '' },
});

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  onSearch: (conditions) => {
    dispatch(getRslCmtList(conditions));
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(RslCmtGuideHeader));
