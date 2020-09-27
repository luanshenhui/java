import React from 'react';
import PropTypes from 'prop-types';
import { reduxForm, Field } from 'redux-form';
import { withRouter } from 'react-router-dom';
import { connect } from 'react-redux';
import qs from 'qs';

import { getConsultListGuideRequest } from '../../modules/reserve/consultModule';

import Button from '../../components/control/Button';
import TextBox from '../../components/control/TextBox';

class ConsultListGuideHeaderForm extends React.Component {
  // コンポーネントがマウントされた直後に1回だけ呼ばれる処理
  componentDidMount() {
    // フォーム入力内容の初期化
    // this.props.reset();

    const { location, onSearch } = this.props;
    // qsを利用してquerystringをオブジェクト型に変換し、onSearchアクションの引数として渡す
    onSearch(qs.parse(location.search.substr(1)));
  }

  // propが更新される際に呼ばれる処理
  componentWillReceiveProps(nextProps) {
    const { location, onSearch } = this.props;
    // ロケーションに変更が発生した場合に検索時イベントを呼び出す
    if (nextProps.location !== location) {
      // qsを利用して変更後ロケーションのquerystringをオブジェクト型に変換し、onSearchアクションの引数として渡す
      onSearch(qs.parse(nextProps.location.search.substr(1)));
    }
  }

  // コンポーネントがアンマウントされる場合の処理
  componentWillUnmount() {
    // フォーム入力内容の初期化
    this.props.reset();
  }

  render() {
    const { onSubmit, handleSubmit } = this.props;
    return (
      <div>
        <form onSubmit={handleSubmit((values) => onSubmit(values))}>
          <Field name="csldate" component={TextBox} />
          <br />
          <Field name="keyword" component={TextBox} />
          &nbsp;&nbsp;
          <Button type="submit" value="検索" />
        </form>
        <p>「」の受診者一覧を表示しています。</p>
      </div>
    );
  }
}

// propTypesの定義
ConsultListGuideHeaderForm.propTypes = {
  // actionと紐付けされた項目
  onSubmit: PropTypes.func.isRequired,
  // redux-form化によって紐付けされた項目
  handleSubmit: PropTypes.func.isRequired,
  reset: PropTypes.func.isRequired,
  location: PropTypes.shape().isRequired,
  onSearch: PropTypes.func.isRequired,
  // csldate: PropTypes.isRequired,
};

const ConsultListGuideHeader = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: 'consultListGuideHeader',
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(ConsultListGuideHeaderForm);

const mapStateToProps = (state) => ({
  initialValues: state.app.reserve.consult.guide.conditions,
});

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  onSearch: (conditions) => {
    const page = 1;
    const limit = 20;
    dispatch(getConsultListGuideRequest({ conditions: { page, limit, ...conditions } }));
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(ConsultListGuideHeader));
