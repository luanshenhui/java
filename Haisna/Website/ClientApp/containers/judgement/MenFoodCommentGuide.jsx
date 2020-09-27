import React from 'react';
import PropTypes from 'prop-types';
import { reduxForm, blur } from 'redux-form';
import { connect } from 'react-redux';
import Button from '../../components/control/Button';
import GuideBase from '../../components/common/GuideBase';
import MenFoodCommentGuideBody1 from './MenFoodCommentGuideBody1';
import MenFoodCommentGuideBody2 from './MenFoodCommentGuideBody2';
import AdviceCommentGuide from '../common/AdviceCommentGuide';
import { changeFoodCommentRequest, updateJudCmtRequest, closeMenFoodCommentGuide } from '../../modules/judgement/interviewModule';

const formName = 'MenFoodCommentGuideForm';

class MenFoodCommentGuide extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  // 登録
  handleSubmit() {
    const { rsvno, onSubmit, foodadvicedata, menuadvicedata, verflag } = this.props;
    // onSubmitアクションの引数として渡す
    onSubmit({ rsvno }, { foodadvicedata, menuadvicedata, verflag });
  }

  render() {
    const { open, handleSubmit, verflag, setParams, commentFlag } = this.props;
    return (
      <GuideBase {...this.props} title="食習慣、献立コメント" usePagination={false} >
        <div style={{ width: 686 }}>
          <form>
            <Button onClick={handleSubmit((values) => this.handleSubmit(values))} value="保存" />
            {
              verflag !== true ?
                <div style={{ height: 400 }}>
                  <MenFoodCommentGuideBody1 {...this.props} />
                </div>
                :
                <div>
                  <MenFoodCommentGuideBody1 {...this.props} />
                  <MenFoodCommentGuideBody2 {...this.props} />
                </div>
            }
          </form>
          <AdviceCommentGuide
            open={open}
            onSelect={(selected) => setParams({ selected, commentFlag })
            }
          />
        </div>
      </GuideBase>
    );
  }
}

const MenFoodCommentGuideForm = reduxForm({
  form: formName,
  enableReinitialize: true,
})(MenFoodCommentGuide);

MenFoodCommentGuide.propTypes = {
  rsvno: PropTypes.string,
  visible: PropTypes.bool.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  onClose: PropTypes.func.isRequired,
  verflag: PropTypes.bool,
  foodadvicedata: PropTypes.arrayOf(PropTypes.shape()),
  menuadvicedata: PropTypes.arrayOf(PropTypes.shape()),
  open: PropTypes.bool.isRequired,
  setParams: PropTypes.func.isRequired,
  commentFlag: PropTypes.string,
};

const mapStateToProps = (state) => ({
  // 可視状態
  visible: state.app.judgement.interview.menFoodCommentGuide.visible,
  verflag: state.app.judgement.interview.menFoodCommentGuide.verflag,
  rsvno: state.app.judgement.interview.menFoodCommentGuide.rsvno,
  foodadvicedata: state.app.judgement.interview.menFoodCommentGuide.foodadvicedata,
  menuadvicedata: state.app.judgement.interview.menFoodCommentGuide.menuadvicedata,
  open: state.app.preference.judCmtStc.adviceCommentGuide.open,
});

// defaultPropsの定義
MenFoodCommentGuide.defaultProps = {
  rsvno: null,
  verflag: undefined,
  commentFlag: undefined,
  foodadvicedata: undefined,
  menuadvicedata: undefined,
};

const mapDispatchToProps = (dispatch) => ({
  onSubmit: (params, data) => {
    dispatch(updateJudCmtRequest({ params, data }));
  },
  setParams: (params) => {
    dispatch(changeFoodCommentRequest(params));
  },
  setValue: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur(formName, name, value));
  },
  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeMenFoodCommentGuide());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(MenFoodCommentGuideForm);
