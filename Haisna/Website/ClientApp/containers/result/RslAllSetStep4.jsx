import React from 'react';
import { withRouter, Link } from 'react-router-dom';
import { reduxForm, getFormValues } from 'redux-form';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import Label from '../../components/control/Label';
import SectionBar from '../../components/SectionBar';
import { FieldGroup, FieldSet } from '../../components/Field';

const formName = 'rslAllSetForm';

class RslAllSetStep4 extends React.Component {
  constructor(props) {
    super(props);
    this.handlNextClick = this.handlNextClick.bind(this);
  }

  handlNextClick() {
    const { onNextClick, params } = this.props;
    onNextClick(params);
  }

  // 描画処理
  render() {
    const { formValues } = this.props;
    return (
      <div>
        <FieldGroup>
          <SectionBar title="入力完了" />
          {!(formValues.selectPerson && formValues.selectPerson.selectPerson && formValues.selectPerson.selectPerson.length > 0) &&
            <FieldSet>
              <Label><span style={{ color: '#ff6600' }}><b>更新が完了しました。</b></span></Label>
            </FieldSet>}
          {formValues.selectPerson && formValues.selectPerson.selectPerson && formValues.selectPerson.selectPerson.length > 0 &&
            <FieldSet>
              <a href="#" onClick={this.handlNextClick} >例外者結果入力</a>
            </FieldSet>}
          <FieldSet>
            <Link to="/contents/result">メニューへ</Link>
          </FieldSet>
        </FieldGroup>
      </div>
    );
  }
}

// propTypesの定義
RslAllSetStep4.propTypes = {
  onNextClick: PropTypes.func.isRequired,
  params: PropTypes.shape(),
  formValues: PropTypes.shape(),
};

RslAllSetStep4.defaultProps = {
  params: undefined,
  formValues: {},
};

const RslAllSetStep4Form = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
  destroyOnUnmount: false,
  forceUnregisterOnUnmount: true,
})(RslAllSetStep4);

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    initialValues: {
      modelInfoThree: state.app.reserve.consult.itemList.modelInfo,
      itemData: state.app.preference.group.itemList.itemData,
      selectPerson: state.app.result.result.itemList.selectPerson,
      grpcd: state.app.reserve.consult.itemList.grpcd,
      cslDate: state.app.reserve.consult.itemList.cslDate,
    },
  };
};

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch, props) => ({

  onNextClick: () => {
    props.onOver();
  },

});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(RslAllSetStep4Form));
