import React from 'react';
import PropTypes from 'prop-types';
import { FieldArray, getFormValues, reduxForm, blur } from 'redux-form';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import PageLayout from '../../../layouts/PageLayout';
import MessageBanner from '../../../components/MessageBanner';
import {
  getPerInspectionRequest,
  getPerInspectionListRequest,
  registerPerInspectionRequest,
  initializePersonIns,
  savePerInspectionIndex,
  refreshPerInspectionSentence,
} from '../../../modules/preference/personModule';
import Button from '../../../components/control/Button';
import MntPerInspectionItems from './MntPerInspectionItems';
import PersonHeader from '../../../containers/common/PersonHeader';
import * as contants from '../../../constants/common';
import { actions as sentenceGuideActions } from '../../../modules/common/sentenceGuideModule';

const formName = 'MntPerInspection';

class MntPerInspection extends React.Component {
  constructor(props) {
    super(props);
    const { match } = this.props;
    this.perid = match.params.perid;

    this.handleCancelClick = this.handleCancelClick.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleClear = this.handleClear.bind(this);

    // ガイドリック時の処理
    this.handleGuildClick = this.handleGuildClick.bind(this);
    // ガイド画面の連絡域に検査項目設定する
    this.handleResult = this.handleResult.bind(this);
  }

  componentDidMount() {
    const { onLoad, match } = this.props;
    onLoad(match.params);
  }

  // 戻るボタンクリック時の処理
  handleCancelClick() {
    const { history } = this.props;
    const { perid } = this.props.match.params;
    history.push(`/contents/preference/person/edit/${perid}`);
  }

  // 文章削除
  handleClear(index) {
    const { perresultitem } = this.props;
    perresultitem[index].shortstc = '';
  }

  // ガイド画面の連絡域に検査項目設定する
  handleResult(selectedItem) {
    const { setValue, perresultitem, selectedItemIndex, selectedItemField, onItemRefresh } = this.props;
    setValue(`${selectedItemField}.result`, selectedItem && selectedItem.stcCd);
    perresultitem[selectedItemIndex].shortstc = selectedItem && selectedItem.shortStc;
    // 画面刷新用
    onItemRefresh();
  }


  // ガイドクリック時の処理
  handleGuildClick(index, field) {
    const { perresultitem, actions, getPerInspectionIndex } = this.props;
    const retype = perresultitem[index].resulttype;
    // ガイドクリック時インデックス保持
    getPerInspectionIndex(index, field);
    switch (retype) {
      // 定性ガイド表示
      case contants.RESULTTYPE_TEISEI1:
      case contants.RESULTTYPE_TEISEI2:
        // onOpenRslCmtGuide();
        break;
      // 文章ガイド表示
      case contants.RESULTTYPE_SENTENCE:
        actions.sentenceGuideOpenRequest({
          itemCd: perresultitem[index].itemcd,
          itemType: perresultitem[index].itemtype,
          onConfirm: (itemgrpdata) => this.handleResult(itemgrpdata),
        });
        break;
      default:
        break;
    }
  }

  // 登録
  handleSubmit(values) {
    const { match, onSubmit } = this.props;
    onSubmit(match.params, values);
  }

  render() {
    const { allcount, perresultitem, handleSubmit, message } = this.props;
    const perresultitemComp = (perresultitem &&
    <FieldArray name="perresultitem" perresultitem={perresultitem} handleGuildClick={this.handleGuildClick} handleClear={this.handleClear} component={MntPerInspectionItems} formName={formName} />);

    return (
      <PageLayout title="個人検査情報メンテナンス">
        <div>
          <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
            <div>
              <Button onClick={this.handleCancelClick} value="戻る" />


              { /* TODO 権限管理 */ }
              { /* if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then
              < INPUT TYPE="image" NAME="save" SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="保存">
                    <%  else    %>
                     &nbsp;
                    <%  end if  %> */ }

              {(allcount > 0) && <Button onClick={handleSubmit((values) => this.handleSubmit(values))} value="保存" />}

            </div>
            <MessageBanner messages={message} />
            <PersonHeader perid={this.perid} />
            <div>
              { perresultitemComp }
            </div>
          </form>
        </div>
      </PageLayout>
    );
  }
}

const MntPerInspectionForm = reduxForm({
  form: formName,
})(MntPerInspection);

MntPerInspection.propTypes = {
  handleSubmit: PropTypes.func.isRequired,
  match: PropTypes.shape().isRequired,
  history: PropTypes.shape().isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  onLoad: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  // ガイド選択された設定インデックス
  selectedItemIndex: PropTypes.number.isRequired,
  selectedItemField: PropTypes.string.isRequired,
  // 個人検査情報
  perresultitem: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  allcount: PropTypes.number.isRequired,
  setValue: PropTypes.func.isRequired,
  actions: PropTypes.shape().isRequired,
  getPerInspectionIndex: PropTypes.func.isRequired,
  onItemRefresh: PropTypes.func.isRequired,
};

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    // 個人検査情報の初期値設定
    initialValues: {
      perresultitem: [],
    },
    formValues,
    // 指定個人IDの個人情報
    personInfo: state.app.preference.person.perInspection.personInfo,
    message: state.app.preference.person.perInspection.message,
    // 個人検査情報
    perresultitem: state.app.preference.person.perInspection.perResultList.perresultitem,
    allcount: state.app.preference.person.perInspection.perResultList.allcount,
    // ガイド選択された設定インデックス
    selectedItemIndex: state.app.preference.person.perInspection.selectedItemIndex,
    selectedItemField: state.app.preference.person.perInspection.selectedItemField,
    // 画面刷新用フラグ
    renderFlag: state.app.preference.person.perInspection.renderFlag,
  };
};

const mapDispatchToProps = (dispatch) => ({
  onLoad: (params) => {
    const { perid } = params;
    if (perid === undefined) {
      return;
    }
    // 画面を初期化
    dispatch(initializePersonIns());
    dispatch(getPerInspectionRequest({ params, formName }));
    dispatch(getPerInspectionListRequest({ params, formName }));
  },

  onSubmit: (params, data) => dispatch(registerPerInspectionRequest({ params, data })),

  // 画面刷新用
  onItemRefresh: () => {
    dispatch(refreshPerInspectionSentence());
  },

  setValue: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur(formName, name, value));
  },

  // ガイド選択された設定インデックス保持
  getPerInspectionIndex: (selectedItemIndex, selectedItemField) => {
    dispatch(savePerInspectionIndex({ selectedItemIndex, selectedItemField }));
  },

  actions: bindActionCreators(sentenceGuideActions, dispatch),

});

export default connect(mapStateToProps, mapDispatchToProps)(MntPerInspectionForm);
