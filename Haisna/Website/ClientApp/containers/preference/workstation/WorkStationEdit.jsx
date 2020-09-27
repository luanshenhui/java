/**
 * @file 管理端末メンテナンス画面
 */
import React from 'react';
import PropTypes from 'prop-types';
import { Field, reduxForm } from 'redux-form';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import qs from 'qs';

// 標準コンポーネント
import PageLayout from '../../../layouts/PageLayout';
import MessageBanner from '../../../components/MessageBanner';
import { FieldGroup, FieldSet, FieldItem } from '../../../components/Field';
import DropDown from '../../../components/control/dropdown/DropDown';
import TextBox from '../../../components/control/TextBox';
import Button from '../../../components/control/Button';

// 共通定数
import * as Constants from '../../../constants/common';

// 管理端末モジュール
import * as workStationModules from '../../../modules/preference/workStationModule';

// グループガイド関連コンポーネント
import GrpGuide from '../../common/GrpGuide';
import GrpParameter from '../../common/GrpParameter';


// 結果入力の印刷ボタンの表示文字列
const isprintbuttonItems = Object.values(Constants.isPrintButton).map((item) => ({ value: item.value, name: item.name }));

const formName = 'WorkStation';

// 管理端末メンテナンス画面
class WorkStationEdit extends React.Component {
  constructor(props) {
    super(props);

    this.handleCancelClick = this.handleCancelClick.bind(this);
    this.handleRemoveClick = this.handleRemoveClick.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  componentDidMount() {
    const { match, workStationActions } = this.props;
    const { params } = match;

    // storeの初期化
    workStationActions.initializeWorkStation();

    // 主キーがセットされていれば読み込む
    if (params.ipaddress) {
      workStationActions.getWorkStationRequest({ formName, conditions: params });
    }
  }

  // 戻るボタンクリック時の処理
  handleCancelClick() {
    const { history, listConditions } = this.props;
    history.push({
      pathname: '/contents/preference/workstation',
      search: qs.stringify(listConditions),
    });
  }

  // 削除
  handleRemoveClick() {
    const { workStationActions, match, history, initialize } = this.props;

    // (とりあえずはconfirm文を使用しているが本来はダイアログのコンポーネントによる出力でなければならない)
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm('このデータを削除しますか？')) {
      return;
    }

    workStationActions.deleteWorkStationRequest({
      params: match.params,
      redirect: () => {
        history.replace('/contents/preference/workstation/edit');
        initialize();
      },
    });
  }

  // 登録
  handleSubmit(values) {
    const { history, match, workStationActions } = this.props;

    workStationActions.registerWorkStationRequest({
      params: match.params,
      data: values,
      redirect: (data) => history.replace(`/contents/preference/workstation/edit/${data.ipaddress}`),
    });
  }

  render() {
    const { handleSubmit, message, match } = this.props;
    const isLoaded = match.params.ipaddress !== undefined;

    const grpdiv = Constants.grpdiv.grpI;

    return (
      <PageLayout title="管理端末メンテナンス">
        <MessageBanner messages={message} />
        <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
          <div>
            <Button type="submit" value="保存" />
            <Button onClick={this.handleCancelClick} value="戻る" />
            <Button onClick={this.handleRemoveClick} disabled={!isLoaded} value="削除" />
          </div>
          <FieldGroup itemWidth={200}>
            <FieldSet>
              <FieldItem>IPアドレス</FieldItem>
              <Field name="ipaddress" component={TextBox} disabled={isLoaded} id="ipaddress" />
            </FieldSet>
            <FieldSet>
              <FieldItem>端末名</FieldItem>
              <Field name="wkstnname" component={TextBox} id="wkstnname" />
            </FieldSet>
            <FieldSet>
              <FieldItem>グループコード</FieldItem>
              <GrpParameter {...this.props} formName={formName} grpdiv={grpdiv} grpCdField="grpcd" grpNameField="grpname" />
            </FieldSet>
            <FieldSet>
              <FieldItem>印刷ボタン表示</FieldItem>
              <Field name="isprintbutton" component={DropDown} id="isprintbutton" items={isprintbuttonItems} addblank />
            </FieldSet>
          </FieldGroup>
        </form>
        <GrpGuide />
      </PageLayout>
    );
  }
}

// redux-form有効化
const WorkStationEditForm = reduxForm({
  form: formName,
})(WorkStationEdit);

// propTypes定義
WorkStationEdit.propTypes = {
  // 登録処理
  handleSubmit: PropTypes.func.isRequired,
  // react-router-domのmatch定義
  match: PropTypes.shape().isRequired,
  // react-router-domのhistory定義
  history: PropTypes.shape().isRequired,
  // メッセージ
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  // 管理端末一覧の検索条件
  listConditions: PropTypes.shape().isRequired,
  // 管理端末アクション
  workStationActions: PropTypes.shape().isRequired,
  initialize: PropTypes.func.isRequired,
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  // redux-formの初期値
  initialValues: {},
  // メッセージ
  message: state.app.preference.workstation.edit.message,
  // 管理端末一覧の検索条件
  listConditions: state.app.preference.workstation.list.conditions,
});

// mapDispatchToPropsではactionをcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  // 管理端末アクション
  workStationActions: bindActionCreators(workStationModules, dispatch),
});

export default connect(mapStateToProps, mapDispatchToProps)(WorkStationEditForm);
