import React from 'react';
import PropTypes from 'prop-types';
import { reduxForm, getFormValues } from 'redux-form';
import { connect } from 'react-redux';
import GuideBase from '../../components/common/GuideBase';
import InterviewHeader from '../../containers/common/InterviewHeaderForm';
import { getEntryRecogLevelList, updateTotalJudCmtRequest, closeEntryRecogLevelGuide } from '../../modules/judgement/interviewModule';
import EntryRecogLevelHeader from './EntryRecogLevelHeader';
import EntryRecogLevelBody from './EntryRecogLevelBody';

const formName = 'entryRecogLevelForm';

class EntryRecogLevelList extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  // コンポーネントがマウントされた直後に1回だけ呼ばれる処理
  componentDidMount() {
    // qsを利用してquerystringをオブジェクト型に変換し、onSearchアクションの引数として渡す
    const { onLoad, match } = this.props;
    onLoad(match.params);
  }

  // propが更新される際に呼ばれる処理
  componentWillReceiveProps(nextProps) {
    const { visible, onLoad, match } = this.props;
    if (!visible && nextProps.visible !== visible) {
      if (match.params.winmode === '1') {
        // onLoadアクションの引数として渡す
        onLoad(match.params);
      }
    }
  }

  // モードを指定してsubmit
  handleSubmit(values) {
    const { match, onSubmit } = this.props;
    if (values.CmtDelFlag) {
      onSubmit(match.params, values, 'del');
    } else {
      onSubmit(match.params, values, 'save');
    }
  }

  // 描画処理
  render() {
    const { handleSubmit, itemName, items, match, list, initialSelected, formValues } = this.props;
    const { params } = match;
    return (
      <div>
        {params.winmode === '1' && (
          <GuideBase {...this.props} title="生活指導コメント" usePagination={false}>
            <InterviewHeader rsvno={this.rsvno} reqwin={0} />
            <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
              <EntryRecogLevelHeader itemName={itemName} items={items} initialSelected={initialSelected} formValues={formValues} />
              <EntryRecogLevelBody list={list} />
            </form>
          </GuideBase>
        )}
        {params.winmode === '0' && (
          <div>
            <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
              <EntryRecogLevelHeader itemName={itemName} items={items} initialSelected={initialSelected} formValues={formValues} />
              <EntryRecogLevelBody list={list} />
            </form>
          </div>
        )}
      </div>
    );
  }
}
// form情報をstateで管理するためにアプリケーションで一意に名前を定義
const EntryRecogLevelForm = reduxForm({
  form: formName,
  enableReinitialize: true,
})(EntryRecogLevelList);

// propTypesの定義
EntryRecogLevelList.propTypes = {
  match: PropTypes.shape().isRequired,
  onSubmit: PropTypes.func.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  onLoad: PropTypes.func.isRequired,
  itemName: PropTypes.shape(),
  items: PropTypes.shape(),
  onClose: PropTypes.func.isRequired,
  list: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  initialSelected: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  formValues: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  visible: PropTypes.bool.isRequired,
};
// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    initialValues: {
      data: state.app.judgement.interview.entryRecogLevel.commentData,
      recoglevel: state.app.judgement.interview.entryRecogLevel.recoglevel,
      itemName: state.app.judgement.interview.entryRecogLevel.itemName,
      items: state.app.judgement.interview.entryRecogLevel.items,
      list: state.app.judgement.interview.entryRecogLevel.list,
      initialSelected: state.app.judgement.interview.entryRecogLevel.judcmtcd,
      visible: state.app.judgement.interview.entryRecogLevel.visible,
    },
    formValues,
    itemName: state.app.judgement.interview.entryRecogLevel.itemName,
    items: state.app.judgement.interview.entryRecogLevel.items,
    list: state.app.judgement.interview.entryRecogLevel.list,
    initialSelected: state.app.judgement.interview.entryRecogLevel.judcmtcd,
    visible: state.app.judgement.interview.entryRecogLevel.visible,
  };
};

EntryRecogLevelList.defaultProps = {
  itemName: undefined,
  items: undefined,
};

const mapDispatchToProps = (dispatch) => ({
  // 画面を初期化
  onLoad: (params) => {
    dispatch(getEntryRecogLevelList({ formName, params }));
  },
  // 画面を Submit
  onSubmit: (params, data, act) => {
    dispatch(updateTotalJudCmtRequest({ params, act, data: { ...data, formName } }));
  },

  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeEntryRecogLevelGuide());
  },

});

export default connect(mapStateToProps, mapDispatchToProps)(EntryRecogLevelForm);
