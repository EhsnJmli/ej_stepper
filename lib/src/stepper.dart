import 'package:flutter/material.dart';

const EdgeInsets _stepsMargin =
    EdgeInsets.symmetric(vertical: 16, horizontal: 8);

enum EJStepState {
  /// A step that is active and can be entered.
  active,

  /// A step that is completed.
  complete,

  /// A step that is disabled and does not to react to taps.
  disable,

  /// A step that is currently having an error. e.g. the user has submitted wrong
  /// input.
  error,
}

class EJStep {
  const EJStep({
    this.title,
    this.content,
    this.state = EJStepState.active,
    this.expandedLeftWidget,
    this.leftWidget,
  }) : assert(state != null);

  final String title;
  final Widget expandedLeftWidget;
  final Widget leftWidget;
  final Widget content;
  final EJStepState state;
}

class EJStepper extends StatefulWidget {
  const EJStepper({
    Key key,
    this.steps,
    this.onStepTapped,
    this.onStepContinue,
    this.onStepCancel,
    this.currentStep,
    this.titleStyle,
    this.backButtonBuilder,
    this.nextButtonBuilder,
    this.leadingActiveColor,
    this.leadingInActiveColor,
    this.onLastStepConfirmTap,
    this.leadingDisableColor,
    this.leadingErrorColor,
    this.leadingCompleteColor,
    this.stepsMargin = _stepsMargin,
  }) : super(key: key);

  final List<EJStep> steps;

  final ValueChanged<int> onStepTapped;

  final ValueChanged<int> onStepContinue;

  final ValueChanged<int> onStepCancel;

  final int currentStep;

  final TextStyle titleStyle;

  final Widget Function(VoidCallback onBackPressed, Widget child, int index)
      backButtonBuilder;

  final Widget Function(VoidCallback onNextPressed, Widget child, int index)
      nextButtonBuilder;

  final Color leadingActiveColor;

  final Color leadingInActiveColor;

  final Color leadingDisableColor;

  final Color leadingErrorColor;

  final Color leadingCompleteColor;

  final VoidCallback onLastStepConfirmTap;

  final EdgeInsets stepsMargin;

  @override
  _EJStepperState createState() => _EJStepperState();
}

class _EJStepperState extends State<EJStepper> {
  int _currentStep = 0;

  @override
  void didUpdateWidget(covariant EJStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentStep != null) {
      _currentStep = widget.currentStep;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.currentStep != null) {
      _currentStep = widget.currentStep;
    }
  }

  Color leadingColor(int index) {
    switch (widget.steps[index].state) {
      case EJStepState.active:
        return index == _currentStep
            ? widget.leadingActiveColor ?? Colors.blue
            : widget.leadingInActiveColor ?? Colors.blue;
      case EJStepState.complete:
        return widget.leadingCompleteColor ?? Colors.green;
      case EJStepState.disable:
        return widget.leadingDisableColor ?? Colors.grey;
      case EJStepState.error:
        return widget.leadingErrorColor ?? Colors.red;
      default:
        return Colors.blue;
    }
  }

  bool _isCurrent(int index) => index == _currentStep;

  void _changeStep(int index) {
    setState(() {
      _currentStep = index;
    });
  }

  void _onBack(int index) {
    if (widget.steps[index - 1].state != EJStepState.disable) {
      _changeStep(index - 1);
      if (widget.onStepCancel != null) {
        widget.onStepCancel(index);
      }
    }
  }

  void _onNext(int index) {
    FocusScope.of(context).requestFocus(FocusNode());
    if (index == widget.steps.length - 1) {
      if (widget.onLastStepConfirmTap != null) {
        widget.onLastStepConfirmTap();
      }
    } else {
      if (widget.steps[index + 1].state != EJStepState.disable) {
        _changeStep(index + 1);
        if (widget.onStepContinue != null) {
          widget.onStepContinue(index);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          shrinkWrap: true,
          children: List.generate(
            widget.steps.length,
            _buildStep,
          ),
        ),
      );

  Widget _buildTitle(int index) => Text(
        widget.steps[index].title,
        style: widget.titleStyle ?? Theme.of(context).textTheme.headline6,
      );

  Widget _buildLeftChild(int index) => _isCurrent(index)
      ? widget.steps[index].expandedLeftWidget
      : widget.steps[index].leftWidget;

  Widget _buildNextButton(int index) {
    final child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(16),
        ),
      ),
      constraints: BoxConstraints(minWidth: 80),
      child: Text(
        index == widget.steps.length - 1
            ? MaterialLocalizations.of(context).okButtonLabel
            : MaterialLocalizations.of(context).continueButtonLabel,
        textAlign: TextAlign.center,
        style:
            Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.white),
      ),
    );
    return widget.nextButtonBuilder != null
        ? widget.nextButtonBuilder(() => _onNext(index), child, index)
        : GestureDetector(onTap: () => _onNext(index), child: child);
  }

  Widget _buildBackButton(int index) {
    final child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadiusDirectional.only(
          bottomStart: Radius.circular(16),
        ),
      ),
      constraints: BoxConstraints(minWidth: 80),
      child: Text(
        MaterialLocalizations.of(context).backButtonTooltip,
        textAlign: TextAlign.center,
        style:
            Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.white),
      ),
    );
    return widget.backButtonBuilder != null
        ? widget.backButtonBuilder(() => _onBack(index), child, index)
        : GestureDetector(onTap: () => _onBack(index), child: child);
  }

  Widget _buildStep(int index) => GestureDetector(
        onTap: () {
          if (index != _currentStep) {
            if (widget.steps[index].state != EJStepState.disable) {
              _changeStep(index);
            }
            if (widget.onStepTapped != null) {
              widget.onStepTapped(index);
            }
          }
        },
        child: Container(
          margin: widget.stepsMargin ?? _stepsMargin,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 8,
              )
            ],
          ),
          constraints: BoxConstraints(minHeight: 70),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.centerStart,
                    children: [
                      Container(
                        height: double.infinity,
                        color: leadingColor(index),
                        width: 15,
                      ),
                      PositionedDirectional(
                        start: -7.5,
                        child: Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadiusDirectional.only(
                              bottomEnd: Radius.circular(100),
                              topEnd: Radius.circular(100),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: AnimatedCrossFade(
                      firstChild: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: _buildTitle(index),
                      ),
                      secondChild: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _buildTitle(index),
                            SizedBox(height: 8),
                            widget.steps[index].content,
                            SizedBox(),
                          ],
                        ),
                      ),
                      firstCurve:
                          const Interval(0, 0.6, curve: Curves.fastOutSlowIn),
                      secondCurve:
                          const Interval(0.4, 1, curve: Curves.fastOutSlowIn),
                      sizeCurve: Curves.fastOutSlowIn,
                      crossFadeState: _isCurrent(index)
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: kThemeAnimationDuration,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (_isCurrent(index) && index != 0)
                        _buildBackButton(index)
                      else
                        SizedBox.shrink(),
                      if (_buildLeftChild(index) != null)
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                            end: 16,
                            bottom: 16,
                            top: 16,
                          ),
                          child: _buildLeftChild(index),
                        )
                      else
                        SizedBox.shrink(),
                      if (_isCurrent(index))
                        _buildNextButton(index)
                      else
                        SizedBox.shrink(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
